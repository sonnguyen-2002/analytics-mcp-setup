# analytics-mcp-setup

Kết nối **Claude Code** và **Codex** với **Google Analytics 4** trên Windows — tải về, bấm đúp, đăng nhập Google là xong.
Dùng MCP chính thức của Google ([googleanalytics/google-analytics-mcp](https://github.com/googleanalytics/google-analytics-mcp)), chạy ngay trên máy bạn và chỉ đọc báo cáo — không sửa được cài đặt GA.

## Cài trên máy mới

1. Tải repo về: nút **Code → Download ZIP** trên trang này, rồi giải nén (hoặc `git clone`).
2. **Bấm đúp `install.cmd`**.
3. Khi trình duyệt mở ra, **đăng nhập tài khoản Google** có quyền xem GA và bấm **Cho phép** — việc duy nhất phải làm tay.
4. Thấy chữ xanh **Done** là xong. Mở **phiên Claude Code hoặc Codex mới** và hỏi, ví dụ:

   > Dùng analytics-mcp xem 7 ngày gần nhất của property 557618398.

Công cụ tự cài những gì máy còn thiếu (Python, pipx, Google Cloud CLI) và tự thêm MCP vào **Claude Code** (mọi dự án) và **Codex** (`config.toml`) — cái nào có trên máy thì cài cái đó. Các MCP khác trong Codex được giữ nguyên; bản cũ của `config.toml` được lưu thành `config.toml.bak`.

Không muốn tải về? Mở PowerShell và chạy một lệnh:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/sonnguyen-2002/analytics-mcp-setup/main/setup.ps1)))
```

## Tuỳ chọn

Thêm sau `install.cmd` (trong cửa sổ dòng lệnh) hoặc sau lệnh một dòng ở trên:

| Tuỳ chọn | Ý nghĩa |
|---|---|
| `-Target claude` / `codex` / `both` | Chỉ cài cho Claude Code, chỉ Codex, hoặc cả hai (mặc định: cái nào có trên máy) |
| `-Name analytics-khach` | Thêm tài khoản Google thứ hai, chạy song song với tài khoản đầu |
| `-Project <project-id>` | Google Cloud project dùng để gọi API (mặc định `sona-511503`) |
| `-Remove` | Gỡ MCP có tên `-Name` khỏi Claude Code, Codex và xoá bản đăng nhập của nó |

Ví dụ: `install.cmd -Name analytics-khach -Project my-project`

`-Project`: tài khoản Google phải có quyền trong project đó, và project phải bật **Google Analytics Data API** và **Google Analytics Admin API**.

## Lỗi hay gặp

- **Không tìm thấy `python` hoặc `gcloud` ngay sau khi vừa cài**: đóng cửa sổ, bấm đúp `install.cmd` lần nữa.
- **Windows hỏi "Cho phép ứng dụng thay đổi thiết bị?"**: bấm **Có** (để cài Python / Google Cloud CLI).

## Bảo mật

Repo này **không chứa bí mật nào**. Thông tin đăng nhập Google của mỗi tài khoản chỉ nằm trên máy, ở `%APPDATA%\analytics-mcp\<tên>.json`. Đừng chép file đó sang máy khác hay đưa lên GitHub — trên máy mới, chạy lại công cụ và đăng nhập lại.

---

**English:** download, double-click `install.cmd`, sign in to Google, then open a new Claude Code or Codex session. It installs what is missing (Python, pipx, Google Cloud CLI) and registers Google's analytics-mcp in Claude Code and/or Codex. Options: `-Target`, `-Name`, `-Project`, `-Remove`. No secrets are stored in this repository.
