## How to use this repo
1. Install Checkov & Terraform
2. Download sample code (this repo)
3. Initialize the Terraform project
4. Run checkov check against main.tf
5. Fix the issues until Checkov passes all checks
6. Cross-reference my solution in fixed_main.tf
7. Add custom policies

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

## Add custom policies
For this demonstration, we’ll be using Python because we’re going to keep it simple. Let’s create a new directory:

```sql
mkdir custom_policies && cd custom_policies
```

Then, in that directory, we need to set up a file named:

```sql
touch __init__.py
```

### Enforcing a specific VPC CIDR block
In that file, we need to add the following: (go ahead and copy/paste this from the repo)

```sql
from os.path import dirname, basename, isfile, join
import glob
modules = glob.glob(join(dirname(__file__), "*.py"))
__all__ = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]
```

From there, we can add our custom checks by creating new files, like this: (in the custom_policies directory)

```sql
touch CustomVPCCIDRBlockCheck.py
```

In that file, paste the following:

```python
from typing import Any

from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class CustomVPCCIDRBlockCheck(BaseResourceCheck):
    def __init__(self) -> None:
        name = "Ensure VPC CIDR block range is within the specified range (10.0.x.x)"
        id = "CUSTOM_AWS_001"
        supported_resources = ("aws_vpc",)
        categories = (CheckCategories.NETWORKING,)
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf: dict[str, Any]) -> CheckResult:
        if 'cidr_block' in conf.keys():
            cidr_block = conf['cidr_block'][0]
            if cidr_block.startswith(("10.0.")):
                return CheckResult.PASSED
        return CheckResult.FAILED

check = CustomVPCCIDRBlockCheck()
```

This basic check will ensure that VPCs are using a CIDR block range within a specific range. In this particular example, we’re looking to make sure it starts with `10.0.`. 

Let’s grab the `vpc.tf` file from the repository if you haven’t already, and let’s take a look at the CIDR block in that file.

We can see that the VPC CIDR block range is configured as: `10.123.0.0/16` which should fail this check. Let’s see if it does!

```
cd ..

checkov --file vpc.tf --external-checks-dir custom_policies
```

The result:

```python
Check: CUSTOM_AWS_001: "Ensure VPC CIDR block range is within the specified range (10.0.x.x)"
	FAILED for resource: aws_vpc.mtc_vpc
	File: /main.tf:1-9

		1 | resource "aws_vpc" "mtc_vpc" {
		2 |   cidr_block           = "10.123.0.0/16"
		3 |   enable_dns_hostnames = true
		4 |   enable_dns_support   = true
		5 | 
		6 |   tags = {
		7 |     Name = "dev"
		8 |   }
		9 | }
```

As we can see, Checkov failed this custom policy check just like it was supposed to! We’ve successfully defined our very first custom policy as code.

### Custom Policy: Preventing t2.micro instances

As another example, let’s write another policy that checks to make sure that we’re not using t2.micro EC2 instances. Your organization might want to do this to control cost, especially if it’s restricting larger instance types, or maybe it wants you to use a different class of instances, like t3 instances instead of t2 instances for performance reasons. Whatever the reason, let’s see how we can do that.

Let’s create a new file:

```sql
touch custom_policies/RestrictEC2InstanceType.py
```

And paste the following code in there:

```sql
from checkov.common.models.enums import CheckCategories, CheckResult
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class AWSEC2InstanceTypeCheck(BaseResourceCheck):
    def __init__(self):
        name = "Ensure that EC2 instances are not t2.micro type"
        id = "CUSTOM_AWS_002"
        supported_resources = ['aws_instance']
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        # Check if the 'instance_type' attribute is set to 't2.micro'
        if 'instance_type' in conf.keys():
            if conf['instance_type'][0] == 't2.micro':
                return CheckResult.FAILED
        return CheckResult.PASSED

check = AWSEC2InstanceTypeCheck()
```

We can then run this policy against our `main.tf` file, although mine isn’t fixed so I’ll use my `fixed_main.tf` file but you can use whatever you’d like.

```json
checkov --file fixed_main.tf --external-checks-dir custom_policies
```

This new policy we just created will fail the check because we’re trying to create a t2.micro which is a violation of our policy. If we were to change that value to t3.micro, though, the check would pass.