# create cluster
eksctl create cluster \
  --name="$EKS_CLUSTER_NAME" \
  --region="$EKS_REGION" \
  --nodegroup-name="$EKS_NODEGROUP_NAME" \
  --node-type="$EKS_NODEGROUP_TYPE" \
  --nodes="$EKS_NODEGROUP_COUNT"
kubectl get pods --all-namespaces

# setup EFS

# setup policies
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.3.2/docs/iam-policy-example.json
aws iam create-policy \
    --policy-name AmazonEKS_EFS_CSI_Driver_Policy \
    --policy-document file://iam-policy-example.json \
    --output text
rm iam-policy-example.json
eksctl create iamserviceaccount \
    --name=efs-csi-controller-sa \
    --namespace=kube-system \
    --cluster="$EKS_CLUSTER_NAME" \
    --attach-policy-arn="arn:aws:iam::$EKS_ACCOUNT_ID:policy/AmazonEKS_EFS_CSI_Driver_Policy" \
    --approve \
    --override-existing-serviceaccounts \
    --region="$EKS_REGION"

# install efs driver
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository="$EKS_CR_ID.dkr.ecr.$EKS_REGION.amazonaws.com/eks/aws-efs-csi-driver" \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
sleep 30
kubectl get pod -n kube-system -l "app.kubernetes.io/name=aws-efs-csi-driver,app.kubernetes.io/instance=aws-efs-csi-driver"

# create EFS
vpc_id=$(aws eks describe-cluster \
    --name "$EKS_CLUSTER_NAME" \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)
cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids "$vpc_id" \
    --query "Vpcs[].CidrBlock" \
    --output text)
security_group_id=$(aws ec2 create-security-group \
    --group-name MyEfsSecurityGroup \
    --description "My EFS security group" \
    --vpc-id "$vpc_id" \
    --output text)
aws ec2 authorize-security-group-ingress \
    --group-id "$security_group_id" \
    --protocol tcp \
    --port 2049 \
    --cidr "$cidr_range" \
    --output text
file_system_id=$(aws efs create-file-system \
    --region "$EKS_REGION" \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)

# create mount targets
kubectl get nodes
aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$vpc_id" \
    --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
    --output table

# TODO analyse output and run this for subnets nodes are in
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-016b8c696b4ed688d \
    --security-groups "$security_group_id"
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-044431af9781bc045 \
    --security-groups "$security_group_id"
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-0e78627acdd7e420a \
    --security-groups "$security_group_id"
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-0fbf4796fdb5b41b5 \
    --security-groups "$security_group_id"
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-06d2d2df99f702eac \
    --security-groups "$security_group_id"
aws efs create-mount-target \
    --file-system-id "$file_system_id" \
    --subnet-id subnet-02f56e26b95c28dd7 \
    --security-groups "$security_group_id"