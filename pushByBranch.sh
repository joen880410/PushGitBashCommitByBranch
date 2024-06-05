#!/bin/bash

# 在裸仓库的根目录下执行以下脚本

# 获取所有的本地分支名称
branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)
echo $branches
# 遍历每一个分支
for branch in $branches; do

	echo === $branch
	
    # 去掉前面的远程名称部分
    local_branch=$(echo $branch | sed 's/origin\///')
	
	echo === $local_branch
	
    # 获取该分支的所有提交哈希值，按照拓扑顺序
    commits=$(git rev-list --topo-order --reverse $branch)

    # 遍历每一个提交哈希值
    for commit in $commits; do
		echo ==== $commit
        # 创建一个新的分支指向该提交
        branch_name=Team_branch_$branch
        git branch $branch_name $commit

        # 推送该分支到远程仓库，使用原分支名称
        git push origin $branch_name:refs/heads/$local_branch

        # 删除临时分支
        git branch -D $branch_name
    done
done
