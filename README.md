## How to use this repo
1. Install Checkov & Terraform
2. Download sample code (this repo)
3. Initialize the Terraform project
4. Run checkov check against main.tf
5. Fix the issues until Checkov passes all checks
6. Cross-reference my solution in fixed_main.tf

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

## Download sample code
There are a few ways of doing this but if you're not super familiar with Git, the easiest way will be to click on `Code` in the top right corner and then `Download ZIP`.

## Initialize Terrform project
Once you've downloaded the sample code (from the prior step), navigate to the directory and type:

```
terraform init
```

You should see output like the following:

```
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.1.0...
- Installed hashicorp/aws v5.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## Run Checkov
There are a few ways of running Checkov scans, but for this tutorial, you can simply run:

```
checkov --file ./main.tf
```

## Fix the issues
As you run your first Checkov test against `main.tf`, you will come across multiple failed checks.

Take your time solving each of those issues so that when you run the Checkov scan, it returns all passing check.

The best way to do this is to read the failure message and to reference the documentation link provided by Checkov. They tell you exactly what the issue is and how to resolve it.

## Check your solution with ours
We've included a fixed main.tf file in this repo that passes all Checkov tests. You can view it in `fixed_main.tf`. However, we recommend trying to fix all of the issues on your own before looking at the answers!