mkdir -p /home/otavio/LPLCv2_crops4

for dir in /home/otavio/images/*; do 
    name=$(basename "$dir")
    mkdir -p "/home/otavio/LPLCv2_crops4/$name"

    for img in "$dir"/*.{jpg,jpeg,png}; do 
        [ -e "$img" ] || continue


        yolo predict model=yolov8m.pt device=0 source="$img" save_crop=True save=False classes=2,3,5,7 project=/home/otavio/tmp_yolo name=temp exist_ok=True >/dev/null 2>&1

        base=$(basename "$img")
        base="${base%.*}"

        i=1
        for crop in /home/otavio/tmp_yolo/temp/crops/*/*; do
            [ -f "$crop" ] || continue

            new_name="${base}_${i}.jpg"
            cp "$crop" "/home/otavio/LPLCv2_crops4/$name/$new_name"

            ((i++))
        done

        
        rm -rf /home/otavio/tmp_yolo/temp
    done
done
