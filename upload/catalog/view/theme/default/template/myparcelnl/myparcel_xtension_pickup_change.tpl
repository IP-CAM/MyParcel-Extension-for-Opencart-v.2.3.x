<table class="table">
    <thead>

    </thead>
    <tbody>
    <?php if(isset($pickup_detail)) { ?>
        <tr>
            <td class="text-left">
                <label for="myparcel_option<?php echo $key; ?>">
                    <?php echo $entry_date ;?> : <?php echo $pickup_detail['date']; ?>
                </label>
            </td>
            <td class="text-right"><label class="text-strong"></label></td>
        </tr>
        <?php foreach($pickup_detail['time'] as $key => $value) { ?>
        <tr>
            <td class="text-left">
                <label for="pickup_option<?php echo $key; ?>">
                    <input type="radio"  class="input-radio" id="pickup_option<?php echo $key; ?>" name="myparcel_option" action="<?php echo $action; ?>" value="<?php echo $shipping_method_code. '-' . $pickup_detail['location'] . '-' .$value['start'];  ?>" <?php echo ($pickup_time_start == $value['start']) ? 'checked' : ''  ?>/>
                    <?php echo $entry_pickup_from ;?> <?php echo $value['start']; ?>
                </label>
            </td>
            <td class="text-right"><label class="text-strong" for="myparcel_option<?php echo $key; ?>"><?php echo $value['price']['text_amount']; ?></label></td>
        </tr>
        <?php } ?>
    <?php } ?>
    </tbody>
</table>