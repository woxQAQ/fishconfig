# 基础命令选项补全
complete -c ksecret -s h -l help -d "显示帮助信息"
complete -c ksecret -s n -l namespace -d "指定 namespace" -x -a "(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')"

# 定义一个函数来获取 secrets
function __ksecret_get_secrets
    set -l cmd (commandline -opc)
    set -l ns "default"
    
    for i in (seq (count $cmd))
        if begin; test "$cmd[$i]" = "-n"; or test "$cmd[$i]" = "--namespace"; end
            set -l next_i (math $i + 1)
            if test $next_i -le (count $cmd)
                set ns "$cmd[$next_i]"
            end
            break
        end
    end
    
    kubectl get secrets -n "$ns" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n'
end

# secret 参数的补全
complete -c ksecret -n "not __fish_seen_subcommand_from -h --help; and not string match -q -- '-*' (commandline -ct)" -a "(__ksecret_get_secrets)" -d "Kubernetes secrets"
