import sensor
import image
import lcd
import KPU as kpu

lcd.init()
lcd.rotation(2)
sensor.reset()
sensor.set_pixformat(sensor.RGB565)
sensor.set_framesize(sensor.QVGA)
sensor.run(1)
task = kpu.load(0x300000) # you need put model(face.kfpkg) in flash at address 0x300000
# task = kpu.load("/sd/face.kmodel")
anchor = (1.889, 2.5245, 2.9465, 3.94056, 3.99987, 5.3658, 5.155437, 6.92275, 6.718375, 9.01025)
a = kpu.init_yolo2(task, 0.5, 0.3, 5, anchor)
while(True):
    img = sensor.snapshot()
    code = kpu.run_yolo2(task, img)
    if code:
        for i in code:
            print(i)
            print(i.rect())
            a = img.draw_cross(i.x()+int(i.w()/2),i.y()+int(i.h()/2),color=248,size=17,thickness=2)
            a = img.draw_circle(i.x()+int(i.w()/2),i.y()+int(i.h()/2), 12, color=248, thickness=2, fill=False)
    a = lcd.display(img)
a = kpu.deinit(task)
