## Setting up Checkov

There are a few ways that we can use, run, or install Checkov on our systems.

### Pip install

The first method we’ll look at is using `pip install`, or more specifically:

```sql
pip3 install checkov
```

This requires having Python ≥ 3.7 installed

### Homebrew install

If you are running a MacOS machine, then you can use homebrew:

```sql
brew install checkov
```

### Docker

If you prefer, you could also use Checkov with Docker:

```sql
docker pull bridgecrew/checkov
docker run --tty --rm --volume /user/tf:/tf --workdir /tf bridgecrew/checkov --directory /tf
```

## Setting up Terraform

There are a few ways that we can use, run, or install Terraform on our systems.

### Linux

Add the official HashiCorp repository to your system:

```sql
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Download the package information from HashiCorp:

```sql
sudo apt update
```

You’re now ready to install Terraform:

```sql
sudo apt-get install terraform
```

You can make sure it installed successfully with:

```sql
terraform -help
```

*(Or if you prefer a manual installation, you can [view instructions here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))*

### Homebrew install

If you are running a MacOS machine, then you can use homebrew:

```sql
brew tap hashicorp/tap

brew install hashicorp/tap/terraform
```

You can make sure it installed successfully with:

```sql
terraform -help
```
