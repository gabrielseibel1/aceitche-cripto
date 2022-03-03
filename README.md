# Aceitche Cripto

A website to help people and businesses accept crypto payments, [aceitchecripto.com](https://aceitchecripto.com).

## Installation

If you're a developer running this project, you can build and install it as follows:

```
# for local setups. must adapt nginx sites with comments
sudo make localhost_certs 

# build and run backend
cargo build --release
sudo killall aceitche-cripto || true
./target/release/aceitche-cripto &

# configure and enable frontend
sudo make frontend

# configure and run BTCPay Server
sudo make payserver
```

