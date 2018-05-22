Windows Updates
===============

This role can be used to check for pending reboots for Windows hosts.

Requirements
------------

* Ansible 2.4
* [Prepared Windows System](http://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

Parameters
----------

* `windows_reboot_allowed`: Determines if reboot of windows machines is allowed.
  When it is set to false and reboot is pending, it will stop execution of the playbook.
  Useful to check before installing updates or installing software.

Example
-------

```yaml
- hosts: win_servers
  vars:
    windows_reboot_allowed: false

  roles:
    - role: valerius257.windows-pending-reboot
```
