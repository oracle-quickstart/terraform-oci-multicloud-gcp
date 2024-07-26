import argparse

import oci
import requests

MAPPED_ATTRIBUTE_VALUE = [
    {
        "managedObjectAttributeName": "$(assertion.fed.nameidvalue)",
        "idcsAttributeName": "userName"
    },
    {
        "managedObjectAttributeName": "$(assertion.LastName)",
        "idcsAttributeName": "name.familyName"
    },
    {
        "managedObjectAttributeName": "$(assertion.PrimaryEmail)",
        "idcsAttributeName": "emails[type eq \"work\" and primary eq true].value"
    },
    {
        "managedObjectAttributeName": "$(assertion.FirstName)",
        "idcsAttributeName": "name.givenName"
    }
]

PATCH_BODY = {
    "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
    "Operations": [
        {
            "op": "replace",
            "path": "attributeMappings",
            "value": MAPPED_ATTRIBUTE_VALUE
        }
    ]
}


# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/clitoken.htm#Running_Scripts_on_a_Computer_without_a_Browser
def get_signer(config: dict):
    token_file = config['security_token_file']
    token = None
    with open(token_file, 'r') as f:
        token = f.read()
    private_key = oci.signer.load_private_key_from_file(config['key_file'])
    return oci.auth.signers.SecurityTokenSigner(token, private_key)


# https://docs.oracle.com/en-us/iaas/tools/python-sdk-examples/2.129.2/identitydomains/patch_identity_provider.py.html
def add_saml_idp_mapped_attribute(config_file_profile, domain_url, new_saml_idp_id):
    config = oci.config.from_file(profile_name=config_file_profile)
    signer = 1
    if "security_token_file" in config:
        signer = get_signer(config)
    else:
        # https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm
        signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
    identity_domains_client = oci.identity_domains.IdentityDomainsClient(config, domain_url, signer=signer)
    identity_domain = identity_domains_client.get_identity_provider(
        identity_provider_id=new_saml_idp_id,
        attributes="jitUserProvAttributes"
    )

    # PATCH update rules
    try:
        url = identity_domain.data.jit_user_prov_attributes.ref
        patch_attribute_mappings_response = requests.patch(url, auth=signer, json=PATCH_BODY)
        if patch_attribute_mappings_response.status_code == 200:
            print("Attribute mapping updated successful!")
        else:
            print(f"Request failed with status code {patch_attribute_mappings_response.status_code}")
    except Exception as e:
        print("Attribute mapping update encountered issue, but would have updated!", e.args[0])


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-p', '--config_file_profile', default='DEFAULT',
                        help='OCI auth profile name',
                        required=False)
    parser.add_argument('-u', '--domain_url',
                        help='domain url eg https://idcs-<token>.identity.oraclecloud.com:443',
                        required=True)
    parser.add_argument('-i', '--saml_idp_id',
                        help='Identity Provider to set the value for the mapped attributes.',
                        required=True)
    args = parser.parse_args()

    add_saml_idp_mapped_attribute(args.config_file_profile, args.domain_url, args.saml_idp_id)
