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