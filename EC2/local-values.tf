locals {
  # Common tags to be assigned to all resources
  common_tags = {
    App_Name        = "CSD"
    Cost_center     = "xyz222"
    Business_unit   = "Training"
    Project         = "CSB"
    App_role        = "web server"
    Customer        = "students"
    Environment     = "dev"
    Confidentiality = "Restricted"
    Owner           = "cloudsecdevops.org"
    Opt_in-Opt_out  = "Yes"
    Application_ID  = "197702"
    Compliance      = "pci"
    Compliance      = "pci"
  }
}
