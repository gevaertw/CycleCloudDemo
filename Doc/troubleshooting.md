## Policies
Its common that an administrator has set restrictions on azure subscriptions. These restrictions can be in the form of policies. If you are unable to create a cluster, it is possible that the policy is blocking the creation.  Typicaly large scale sets, certain regios, certian VM SKU's...  Check with your admin if required.

## Log files

| Server       | Purpose                                           | Path                                                                 |
|--------------|---------------------------------------------------|----------------------------------------------------------------------|
| CycleCloud   | CycleCloud server application logs                | /opt/cycle_server/logs/cycle_server.log                              |
| CycleCloud   | Log of all API requests to Azure from CycleCloud  | /opt/cycle_server/logs/azure-*.log                                   |
| Cluster Node | Chef logs/troubleshooting software installation issues | /opt/cycle/jetpack/logs/chef-client.log                              |
| Cluster Node | Detailed chef stacktrace output                   | /opt/cycle/jetpack/system/chef/cache/chef-stacktrace.out             |
| Cluster Node | Detailed cluster-init log output                  | /opt/cycle/jetpack/logs/cluster-init/{PROJECT_NAME}                  |
| Cluster Node | Waagent logs (used to install Jetpack)            | /var/log/waagent.log                                                 |

Cluster node can be scheduler, htc, logon or any other node in the cluster, CycleCloud is the VM where CycleCloud is installed.