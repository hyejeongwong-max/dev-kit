---
name: dev-handbook
description: 维护用户的飞书开发手册：用 lark-cli 读取、修改章节并追加更新记录。用户说"更新手册""记进手册""写进飞书文档"，或者对话中总结出新的开发教程、模板、踩坑经验时使用。
---

# 维护飞书开发手册

## 配置

- 手册链接：https://my.feishu.cn/docx/MMWAdnbsAopQcFxcjaJctyX9nwf
- 文档 ID：`MMWAdnbsAopQcFxcjaJctyX9nwf`

以上是作者本人的手册。其他人使用时，把这两行换成自己的飞书文档；还没有手册时，用 `lark-cli docs +create --as user --title "我的开发手册" --doc-format markdown --content "# 我的开发手册"` 新建一篇，再把链接和 ID 填到这里。当前项目的 `AGENTS.md` 里写了别的手册链接时，以项目里的为准。

工具：`lark-cli`（飞书官方命令行），所有命令都带 `--as user`，需要网络权限。下文 `<ID>` 指上面的文档 ID。

## 什么时候主动提议

对话里出现新手容易再踩的坑、能复用的模板、新的进阶做法时，问用户"要不要记进飞书手册？"，同意了再写。

## 步骤

1. 读大纲：
   `lark-cli docs +fetch --as user --doc <ID> --scope outline --doc-format markdown`
2. 决定放在哪：属于已有章节就补进那一节；全新主题就在"手册怎么维护 + 更新记录"这一节前面加一个新章节，并把后面章节的编号顺延。
3. 拿 block id：
   `lark-cli docs +fetch --as user --doc <ID> --scope keyword --keyword "<关键词>" --detail with-ids`
4. 把内容写进**当前目录**下的临时文件（`@file` 只接受当前目录的相对路径），格式用 markdown：
   - 在某块后插入：`lark-cli docs +update --as user --doc <ID> --command block_insert_after --block-id <id> --doc-format markdown --content @_tmp.md`
   - 替换某块：`--command block_replace --block-id <id>`
   - 改一小段文字：`--command str_replace --pattern '旧文字' --content '新文字'`
   - 不要用 `overwrite` 覆盖全文，用户可能在飞书里手动改过。
5. 在"更新记录"列表最后一条后面追加一条：`- **YYYY-MM-DD**：改了什么`
6. 删除临时文件，重新拉一次大纲确认结构正确，把文档链接发给用户并说明改了哪些地方。

## 写作要求

- 读者是编程新手：中文、短句、大白话；术语第一次出现时顺带解释。
- 模板放在代码块里，方便复制。
- 普通文本里的 `* _ [ ] $ ~ <` 要用反斜杠转义（代码块里不用）。

## 出错时

- **提示未登录或授权过期**：运行 `lark-cli auth login --recommend --no-wait --json`，再用 `lark-cli auth qrcode "<verification_url>" --output /tmp/feishu-auth-qr.png` 生成二维码，把链接和二维码图片发给用户，然后结束这一轮。用户说授权完成后，运行 `lark-cli auth login --device-code <device_code>`。
- **找不到 `lark-cli`**：运行 `npm install -g --allow-scripts=@larksuite/cli @larksuite/cli`，再运行 `lark-cli config init` 配置应用凭证。App Secret 让用户自己在终端里输入，不要让用户贴进对话。
