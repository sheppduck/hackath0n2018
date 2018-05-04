#!/bin/bash
set -x
# set -e

OC_SERVER="18.218.176.19"
OC_UN="clustadm"
OC_PW="devops123!"
OC_PROJECT="myhub"
OC_CP_TMP="/tmp"
OC_TAR_DIR="/temp/hackathon2018"
# switch to the myhub project run oc to get PODS from myhub ns grep for solr
# and save output as a variable
oc login $OC_SERVER:8443 --username=$OC_UN --password=$OC_PW --insecure-skip-tls-verify
oc project $OC_PROJECT
## Grep for and add some add'l HUB PODs - how to use $1, $2, etc. for POD name vars?

# Get all Namespaces and stuff into an array, trim the first line of the oc get
GET_ALL_NS=array_of_ns=("${(@f)$(oc get ns | cut -d ' ' -f1 | awk '{if(NR>1)print}')}")
NS=$1
PODS=$2
OC_OUT_DIR=$3
WEBAPP="$(oc get pods | grep webapp | cut -d ' ' -f1)"
echo "$WEBAPP"
SOLR="$(oc get pods | grep solr | cut -d ' ' -f1)"
echo "$SOLR"

# now let's copy some files out of the hub-solr container
# oc cp usage is 'oc cp <namespace/project>/POD:files_to_copy_from_pod /save/files/to/local/dir'
# ... flesh this part out ... for other containers, get /bin of any test container...

oc cp $OC_PROJECT/$WEBAPP:/bin $OC_CP_TMP
oc cp $OC_PROJECT/$SOLR:/opt/solr/ $OC_CP_TMP
oc cp $OC_PROJECT/$SOLR:/bin/ $OC_CP_TMP
# Example?
# oc cp $1/$2:/bin


cd /tmp && ls -l
mkdir -p $OC_TAR_DIR
chmod 777 $OC_TAR_DIR
tar -cvzf $OC_TAR_DIR/hackathon2018.tar $OC_CP_TMP
ls -l $OC_TAR_DIR
