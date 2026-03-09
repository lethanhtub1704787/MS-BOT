import ctypes
import os
import socket
import time
from datetime import datetime

import cv2

hwnd = ctypes.windll.kernel32.GetConsoleWindow()
if hwnd:
    screen_width = ctypes.windll.user32.GetSystemMetrics(0)
    start_x = screen_width - 550
    ctypes.windll.user32.MoveWindow(hwnd, start_x, 0, screen_width - start_x, 600, True)
from ultralytics import YOLO

# --- CẤU HÌNH SOCKET SERVER ---
HOST = "127.0.0.1"
PORT = 65432


def SolveRune(image):
    os.makedirs("Solved", exist_ok=True)
    os.makedirs("Failed", exist_ok=True)

    results = model.predict(source=image, line_width=1)
    for result in results:
        img = result.plot()
        boxes = result.boxes

        # Lấy số lượng bounding box
        num_boxes = len(boxes)

        x_coords = boxes.xyxy[:, 0].tolist()

        class_indices = result.boxes.cls.int().tolist()

        # Ghép lại thành list (x, class_index)
        pairs = list(zip(x_coords, class_indices))

        # Sắp xếp theo x tăng dần
        sorted_pairs = sorted(pairs, key=lambda p: p[0])

        # Chỉ lấy index class theo thứ tự x
        sorted_class_indices = [cls for _, cls in sorted_pairs]

        # Lấy thời gian hiện tại và format thành chuỗi
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        # Tạo đường dẫn file lưu

        if num_boxes == 4:
            save_path = os.path.join("Solved", f"{timestamp}.jpg")
        else:
            save_path = os.path.join("Failed", f"{timestamp}.jpg")

        # Lưu ảnh
        cv2.imwrite(save_path, img)

        print(f"Ảnh đã lưu tại: {save_path}")

    return sorted_class_indices


def start_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        # Cấu hình để có thể khởi động lại server nhanh chóng (tránh lỗi Address already in use)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((HOST, PORT))
        s.listen()
        print(f"Server Socket đang chạy tại {HOST}:{PORT}...")

        while True:
            try:
                conn, addr = s.accept()
                with conn:
                    # Nhận đường dẫn ảnh từ Client
                    data = conn.recv(1024).decode().strip()
                    if not data:
                        continue
                    result = SolveRune(data)
                    print("result: ", result)
                    conn.sendall(f"{result}".encode())

            except KeyboardInterrupt:
                print("\nĐang tắt Server...")
                break
            except Exception as e:
                print(f"Lỗi kết nối: {e}")


if __name__ == "__main__":

    model_path = "AI_Models/rune_yolov8m_model/last.pt"
    model = YOLO(model_path)
    start_server()
