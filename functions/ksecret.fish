function ksecret
    argparse 'h/help' 'n/namespace=' -- $argv 2>/dev/null
    or begin
        echo "参数解析错误！"
        return 1
    end

    # 显示帮助信息
    if set -q _flag_help
        echo "用法: ksecret [-n|--namespace <namespace>] <Secret>"
        echo "选项:"
        echo "  -n, --namespace    指定 Kubernetes namespace (默认: default)"
        echo "  -h, --help        显示帮助信息"
        echo
        echo "示例:"
        echo "  ksecret --namespace default my-secret"
        echo "  ksecret my-secret"
        return 0
    end

    # 设置 namespace，默认为 default
    set -l namespace "default"
    if set -q _flag_namespace
        set namespace $_flag_namespace
    end

    # 获取 secret 名称
    set -l secret_name $argv[1]
    if test -z "$secret_name"
        echo "错误: 必须指定 Secret 名称"
        ksecret --help
        return 1
    end

    # 获取并显示 secret 数据
    set -l secret_data (kubectl get secret -n $namespace $secret_name -o json 2>/dev/null | jq -r '.data | to_entries | .[] | "\(.key): \(.value | @base64d)"')
    if test $status -ne 0 -o -z "$secret_data"
        echo "错误: 在 namespace '$namespace' 中未找到 secret '$secret_name'"
        return 1
    end

    echo "Secret $secret_name 的内容 (namespace: $namespace):"
    echo $secret_data
end
