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