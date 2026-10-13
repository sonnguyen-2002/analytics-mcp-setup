# analytics-mcp-setup

Kết nối **Claude Code** với **Google Analytics 4** bằng một lệnh, trên Windows.
Dùng MCP chính thức của Google ([googleanalytics/google-analytics-mcp](https://github.com/googleanalytics/google-analytics-mcp)), chỉ đọc báo cáo — không sửa được cài đặt GA.

## Cài trên máy mới

Mở PowerShell rồi chạy **một lệnh** (không cần tải repo về):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/sonnguyen-2002/analytics-mcp-setup/main/setup.ps1)))
```

Hoặc tải repo về rồi chạy:

```powershell
git clone https://github.com/sonnguyen-2002/analytics-mcp-setup.git
cd analytics-mcp-setup
powershell -ExecutionPolicy Bypass -File setup.ps1
```

Công cụ tự cài Python, pipx và Google Cloud CLI nếu máy chưa có, mở trình duyệt để bạn **đăng nhập Google** (việc duy nhất phải làm tay), rồi thêm MCP `analytics-mcp` cho mọi dự án Claude Code.

Xong thì mở **một phiên Claude Code mới** và hỏi, ví dụ:

> Dùng analytics-mcp xem 7 ngày gần nhất của property 557618398.

## Thêm tài khoản Google khác

Mỗi tài khoản là một MCP riêng, dùng song song được:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/sonnguyen-2002/analytics-mcp-setup/main/setup.ps1))) -Name analytics-khach -Project <project-id>
```

`-Project` là Google Cloud project dùng để gọi API: tài khoản phải có quyền trong project đó, và project phải bật **Google Analytics Data API** và **Google Analytics Admin API**.

## Gỡ

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1 -Name analytics-mcp -Remove
```

## Bảo mật

Repo này **không chứa bí mật nào**. Thông tin đăng nhập Google của mỗi tài khoản chỉ nằm trên máy, ở `%APPDATA%\analytics-mcp\<tên>.json`. Đừng chép file đó sang máy khác hay đưa lên GitHub — trên máy mới, chạy lại công cụ và đăng nhập lại.

---

**English:** one-command setup of Google's analytics-mcp for Claude Code on Windows. Run `setup.ps1`, sign in to Google in the browser, then open a new Claude Code session. Use `-Name` for extra accounts and `-Remove` to uninstall. No secrets are stored in this repository.
