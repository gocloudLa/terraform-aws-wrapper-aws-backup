locals {

  selections_tmp = [for key, value in var.backup_plan : # in this line, we reference the key and content of variable
    {
      for key1, value1 in value.selections : # in this line, we reference the the key inside  a variable of the content of the first line
      "${key1}" =>                           # in this line, we combine custom keys to avoid grouping variables with same names
      {
        backup_plan    = key #this key is from the first for
        resources      = lookup(value1, "resources", [])
        not_resources  = lookup(value1, "not_resources", [])
        conditions     = lookup(value1, "conditions", {})
        selection_tags = lookup(value1, "selection_tags", [])
      }
    } if lookup(value, "selections", null) != null
  ]

  selections = merge(local.selections_tmp...)
}