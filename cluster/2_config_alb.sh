# setup load balancer
eksctl utils associate-iam-oidc-provider \
  --region="$EKS_REGION" \
  --cluster="$EKS_CLUSTER_NAME" \
  --approve
curl -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.1/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
rm iam_policy.json
eksctl create iamserviceaccount \
  --region="$EKS_REGION" \
  --cluster="$EKS_CLUSTER_NAME" \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn="arn:aws:iam::$EKS_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy" \
  --override-existing-serviceaccounts \
  --approve
kubectl annotate serviceaccount -n kube-system aws-load-balancer-controller \
    eks.amazonaws.com/sts-regional-endpoints=true
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$EKS_CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository="$EKS_CR_ID.dkr.ecr.$EKS_REGION.amazonaws.com/amazon/aws-load-balancer-controller"
sleep 10
kubectl get deployment -n kube-system aws-load-balancer-controller
