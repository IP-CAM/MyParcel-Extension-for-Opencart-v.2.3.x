<table class="table">
    <thead>

    </thead>
    <tbody>
    <?php if(isset($delivery_detail)) { ?>
    <?php foreach($delivery_detail['time'] as $key => $time ) { ?>
    <tr>
        <td class="text-left">
            <label for="delivery_option<?php echo $key; ?>">
                <input type="radio"   class="input-radio" id="delivery_option<?php echo $key; ?>" name="myparcel_option" value="<?php echo $shipping_method_code. '-' .$time['start'] . '-' . $time['end']; ?>" action="<?php echo $action; ?>" <?php echo ($delivery_time_start == $time['start'] && $delivery_time_end == $time['end']) ? 'checked' : ''  ?> />
                <?php echo $time['start']; ?> - <?php echo $time['end']; ?>
                <div class="myparceltext"><?php echo ucfirst($time['price_comment_text']); ?></div>
            </label>
        </td>
        <td class="text-right"><label class="text-strong" for="myparcel_option<?php echo $key; ?>"><?php echo $time['price']['text_amount']; ?></label></td>
    </tr>
    <?php } ?>
    <?php if(isset($additional_service)){ ?>
    <tr>
        <td><?php echo $additional_title; ?></td>
        <td></td>
    </tr>
    <?php foreach($additional_service as $key => $value){
    if($value != 'disable') { ?>
    <tr>
        <td class="text-left">
            <label  for="additional_<?php echo $key; ?>">
                <input type="checkbox"  class="input-checkbox myparcel_additional" id="additional_<?php echo $key?>" name="additional_<?php echo $key?>" onclick="changeAdditionalService(this,'<?php echo $key?>')" value="<?php echo $value['amount']; ?>" action="<?php echo $action; ?>" <?php echo (isset($myparcel_additional_checked[$key]) && $myparcel_additional_checked[$key])?'checked' : '';?> />
                <?php echo $value['title']; ?>
            </label>
        </td>
        <td class="text-right"><label class="text-strong" for="myparcel_additional_<?php echo $key; ?>"><?php echo $value['text_amount']; ?></label></td>
    </tr>
    <?php   }} ?>
    <?php } ?>
    <?php } ?>
    </tbody>
</table>