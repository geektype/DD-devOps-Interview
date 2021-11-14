from typing import List
from boto3 import (
    client,
    resource,
)


def fetchDefaultVPCs(_client: client) -> List[str]:
    vpc_list = []
    vpcs = _client.describe_vpcs(Filters=[{"Name": "isDefault", "Values": ["true"]}])[
        "Vpcs"
    ]

    for vpc in vpcs:
        vpc_list.append(vpc["VpcId"])

    return vpc_list


def deleteVpc(vpc) -> bool:
    try:
        print(f"Deleting {vpc.id}...", end="")
        vpc.delete()
        print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print("Failed to delete. VPC has existing dependants!")


def deleteSecurityGroups(vpc):
    try:
        vpc_sgs = vpc.security_groups.all()
        if vpc_sgs:
            for sg in vpc_sgs:
                # Skip deletion of default security group
                if sg.group_name == "default":
                    print(
                        f"{sg.id} belongs to default group, cannot delete. \033[38;5;208mSkipping...\033[0;0m"
                    )
                    continue
                print(f"Deleting {sg.id}...", end="")
                sg.delete()
                print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print(f"\033[38;5;160mFAILED deleting Security Group\033[0;0m")


def deleteIGW(vpc, vpc_id):
    try:
        igws = vpc.internet_gateways.all()
        for igw in igws:
            print(f"Detaching and deleting {igw.id}...", end="")
            # Detach from VPC before deleing
            igw.detach_from_vpc(VpcId=vpc_id)
            igw.delete()
            print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print(f"\033[38;5;160mFAILED deleting Internet Gateway\033[0;0m")


def deleteSubnets(vpc):
    try:
        subnets = vpc.subnets.all()
        for subnet in subnets:
            print(f"Deleting {subnet.id}...", end="")
            subnet.delete()
            print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print(f"\033[38;5;160mFAILED deleting Subnet\033[0;0m")


def deleteRouteTables(vpc):
    try:
        route_tables = vpc.route_tables.all()
        for rtb in route_tables:
            # Check if RT is main. If so then skip
            assoc_attr = [rtb.associations_attribute for rtb in route_tables]
            if assoc_attr[0][0]["Main"]:
                print(f"{rtb.id} is main. \033[38;5;208mSkipping...\033[0;0m")
                continue

            print(f"Removing rtb-id: {rtb.id}", end="")
            rtb.delete()
            print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print(f"\033[38;5;160mFAILED deleting Route Table\033[0;0m")


def deleteNacls(vpc):
    try:
        nacls = vpc.network_acls.all()
        for nacl in nacls:
            # Check if Nacl is default. If so then skip
            if nacl.is_default:
                print(
                    f"{nacl.id} is default network nACL, cannot delete. \033[38;5;208mSkipping...\033[0;0m"
                )
                continue
            print(f"Deleting {nacl.id}...", end="")
            nacl.delete()
            print("\033[38;5;46m done\033[0;0m")
    except Exception as e:
        print(f"\033[38;5;160mFAILED deleting NACL\033[0;0m")


_client = client("ec2")

region_dump = _client.describe_regions()["Regions"]
for region in region_dump:
    _client = client("ec2", region_name=region["RegionName"])
    _ec2 = resource("ec2", region_name=region["RegionName"])

    default_vpcs = fetchDefaultVPCs(_client)
    if default_vpcs:
        print(
            f"Found {len(default_vpcs)} Vpc(s) in {region['RegionName']}. Attempting to delete..."
        )
    else:
        print(
            f"Found no Vpc in {region['RegionName']}. \033[38;5;208mSkipping...\033[0;0m"
        )
    for vpc in default_vpcs:
        vpc_r = _ec2.Vpc(vpc)
        deleteRouteTables(vpc_r)
        deleteIGW(vpc_r, vpc)
        deleteSubnets(vpc_r)
        deleteNacls(vpc_r)
        deleteSecurityGroups(vpc_r)
        deleteVpc(vpc_r)
