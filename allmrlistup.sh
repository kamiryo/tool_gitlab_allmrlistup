#!/bin/bash

# 初期ページ番号を設定
page=1

# 最大ページ数（仮の値、適宜調整してください）
max_pages=1000

# プロジェクトID
project_id=

while [ $page -le $max_pages ]; do
    echo "page=$page"
    # glabコマンドを実行し、指定したページのMRを取得し、JSON形式で出力
    mr_list_json=$(glab mr list -p project_id --all --page $page -F json)
    if [ "$mr_list_json" == "[]" ]; then
        echo "No more merge requests found. Exiting loop."
        break
    fi

    # JSON形式のMRリストから、更に詳細を取得
    # 例：タイトルにHTMLが含まれている際はjqでフィルタする場合
    #ids_to_check=$(echo "$mr_list_json" | jq -r '.[] | select(.title | contains("HTML")) | .iid')
    ids_to_check=$(echo "$mr_list_json" | jq -r '.[] | select(.iid')
    echo "ids_to_check=$ids_to_check"

    for id in $ids_to_check; do
        # 特定のMRについての詳細を取得し、JSON形式で出力
        mr_detail_json=$(glab mr view $id -F json)
        echo "mr_detail_json=$mr_detail_json"
    done

    # 次のページへ
    ((page++))
done