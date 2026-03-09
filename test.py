import os

import cv2
from ultralytics import YOLO


def return_direction_key(class_index):
    if class_index == 0 or class_index == 4:
        return "left"
    if class_index == 1 or class_index == 5:
        return "right"
    if class_index == 2 or class_index == 6:
        return "up"
    if class_index == 3 or class_index == 7:
        return "down"


image_path = "runes/"
image_list = os.listdir(image_path)

model_path = "AI_Models/rune_yolov8m_model/last.pt"
model = YOLO(model_path)

for each in image_list:
    results = model.predict(source=image_path + each, line_width=1, stream=True)
    for result in results:
        class_indices = result.boxes.cls.int().tolist()
        print(class_indices)
        img = result.plot()  # vẽ bounding boxes lên ảnh
        cv2.imshow("Result", img)
        cv2.waitKey(0)
    cv2.destroyAllWindows()
