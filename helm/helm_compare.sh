#!/usr/bin/env bash
#
# usage:
#   ./service_list.sh <src env> <src cluster> <dst env> <dst cluster>
#

# $1: temp file
function __fetch_services() {
    helm ls --output json \
        | jq --slurp '[ .[0].Releases[] 
        | .Namespace as $prod 
        | .Name as $serv 
        | {Product: .Namespace, 
            Service: .Name | ltrimstr($prod+"-"), 
            ChartVersion: .Chart | ltrimstr($serv+"-")} ]' \
        | jq --slurp --raw-output '.[][] | [.Product, .Service, .ChartVersion] | @tsv' \
            >> $1
}

# TODO: $(mktemp)
src_services_json=src.json
dst_services_json=dst.json

src_services_list=src.list
dst_services_list=dst.list

src_env=$1
dst_env=$3
src_cluster="stable"
dst_cluster="stable"
# special check because there is no "stable0" cluster
if [ "$2" != "0" ]; then
    src_cluster+=$2
fi
if [ "$4" != "0" ]; then
    dst_cluster+=$4
fi

# hacky header
echo ${src_env}_${src_cluster} > ${src_services_json}
echo "======= ======= =============" >> ${src_services_json}
echo "PRODUCT SERVICE CHART_VERSION" >> ${src_services_json}
echo "======= ======= =============" >> ${src_services_json}

telin ${src_env} ${src_cluster}
__fetch_services ${src_services_json}

# hacky header
echo ${dst_env}_${dst_cluster} > ${dst_services_json}
echo "======= ======= =============" >> ${dst_services_json}
echo "PRODUCT SERVICE CHART_VERSION" >> ${dst_services_json}
echo "======= ======= =============" >> ${dst_services_json}

telin ${dst_env} ${dst_cluster}
__fetch_services ${dst_services_json}

column -t ${src_services_json} > ${src_services_list}
column -t ${dst_services_json} > ${dst_services_list}
diff --ignore-all-space \
    --minimal \
    --side-by-side  --width=180 \
    ${src_services_list}  ${dst_services_list} \
     | colordiff

rm ${src_services_json}
rm ${dst_services_json}

mv  ${src_services_list} ${src_services_list}.cached
mv  ${dst_services_list} ${dst_services_list}.cached

# helm ls --output json \
#     | jq --slurp '[ .[0].Releases[]
#         | .Namespace as $prod
#         | .Name as $serv
#         | {Product: .Namespace,
#             Service: .Name | ltrimstr($prod+"-"),
#             ChartVersion: .Chart | ltrimstr($serv+"-")} ]' \
#     | jq --slurp '.[]
#         | group_by(.Product)[]
#         | { "Product": (.[0].Product),
#             "Services" : [.[] | {Service, ChartVersion}] }' \
#     | tee services.json
#
