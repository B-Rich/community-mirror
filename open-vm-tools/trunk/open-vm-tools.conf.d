# Enable support for Drag'n'Drop
VM_DRAG_AND_DROP="yes"

# Load these modules on startup
VM_MODULES=('vmci' 'vsock' 'vmhgfs' 'vmsync')

# vmware-guestd settings
GUESTD_BIN="/usr/sbin/vmware-guestd"
PIDFILE="/var/run/vmware-guestd.pid"
