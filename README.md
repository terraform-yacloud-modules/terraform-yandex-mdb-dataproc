# Yandex Cloud <RESOURCE> Terraform module

Terraform module which creates Yandex Cloud <RESOURCE> resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_dataproc_cluster.dataproc_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/dataproc_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Version of Data Proc image | `string` | `"2.0"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Inhibits deletion of the cluster | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Data Proc cluster | `string` | `"Dataproc Cluster created by Terraform"` | no |
| <a name="input_hadoop_properties"></a> [hadoop\_properties](#input\_hadoop\_properties) | A set of key/value pairs that are used to configure cluster services | `map(string)` | `{}` | no |
| <a name="input_hadoop_services"></a> [hadoop\_services](#input\_hadoop\_services) | List of services to run on Data Proc cluster | `list(string)` | <pre>[<br>  "HDFS",<br>  "YARN",<br>  "SPARK",<br>  "TEZ",<br>  "MAPREDUCE",<br>  "HIVE"<br>]</pre> | no |
| <a name="input_initialization_actions"></a> [initialization\_actions](#input\_initialization\_actions) | List of initialization scripts | <pre>list(object({<br>    uri     = string<br>    args    = list(string)<br>    timeout = number<br>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the Data Proc cluster | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Data Proc cluster | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs that the cluster belongs to | `list(string)` | `[]` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service account ID to be used by the Data Proc agent | `string` | n/a | yes |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | List of SSH public keys to put to the hosts of the cluster | `list(string)` | `[]` | no |
| <a name="input_subcluster_specs"></a> [subcluster\_specs](#input\_subcluster\_specs) | Configuration of the Data Proc subcluster | <pre>list(object({<br>    name = string<br>    role = string<br>    resources = object({<br>      resource_preset_id = string<br>      disk_type_id       = string<br>      disk_size          = number<br>    })<br>    subnet_id        = string<br>    hosts_count      = number<br>    assign_public_ip = bool<br>    autoscaling_config = list(object({<br>      max_hosts_count        = number<br>      preemptible            = bool<br>      warmup_duration        = number<br>      stabilization_duration = number<br>      measurement_duration   = number<br>      cpu_utilization_target = number<br>      decommission_timeout   = number<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_ui_proxy"></a> [ui\_proxy](#input\_ui\_proxy) | Whether to enable UI Proxy feature | `bool` | `false` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of the availability zone to create cluster in | `string` | `"ru-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Creation timestamp of the Data Proc cluster. |
| <a name="output_id"></a> [id](#output\_id) | ID of the Data Proc cluster. |
| <a name="output_name"></a> [name](#output\_name) | Name of the Data Proc cluster. |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | Service account ID used by the Data Proc cluster. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Zone ID of the Data Proc cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).
