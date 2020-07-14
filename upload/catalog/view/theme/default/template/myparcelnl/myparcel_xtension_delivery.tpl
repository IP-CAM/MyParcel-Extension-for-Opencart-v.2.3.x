<?php if(isset($shipping_method_code)) { ?>
<?php if($shipping_method_code == 'delivery'){ ?>
<div id="xdeldateandtimeslots" class="xdeldateandtimeslots myparceldatetime">
    <div class="group nomarginbottom" id="regular-field-dateselector">
        <div class="input-group xdelslotdate myparceldate">
            <span class="input-group-btn"><button onclick="$(this).closest('.group').addClass('filled');" type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button></span>
            <input  type="text" name="delivery_date" readonly="readonly" value="<?php echo date('d-m-Y',strtotime($date)); ?>" data-date-format="<?php echo $date_format; ?>" id="xdelslot_deliverydate" class="inputMaterial" />
            <label for="xdelslot_deliverydate"><?php echo $entry_delivery_date; ?><span class="fieldlabel required"></span></label>
        </div>
    </div>
    <div id="xdeltimeslots" class="xdeltimeslots"></div>
</div>

<script type="text/javascript">
    $('.xdelslotdate input').click(function(event){
        $('.xdelslotdate ').data("DateTimePicker").show();
    });
    $('.xdelslotdate').datetimepicker({
        pickTime: false,
        useCurrent: false,
        minDate: moment("<?php echo $min_date; ?>"),
        maxDate: moment("<?php echo $max_date; ?>"),
        daysOfWeekDisabled: [<?php echo $dropoff_days; ?>]
    }).on('dp.change', function (e) {
        showLoader();
        $.ajax({
            url: 'index.php?route=<?php echo $action; ?>/change',
            type: 'post',
            data: $('#regular-field-dateselector input'),
            dataType: 'json',
            beforeSend: function() {
                $('.xdeldateandtimeslots .alert').remove();
            },
            success: function(json) {
                if(json['error']){
                    if(json['error']['date']){
                        $('#xdeltimeslots').before('<div class="alert alert-warning">'+json['error']['date']+'<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
                    }
                }else if(json['success']){
                    $('.myparcel-delivery-table').html(json['html']);
                    loadShippingMethods(true);
                }
                hideLoader();
            }
        });
    });
</script>

<?php
        foreach($myparcel_delivery_option as $value) {
            if(date('d-m-Y',strtotime($value['date'])) == date('d-m-Y',strtotime($date)) ){ ?>
<div class="xdeltimeslots-table myparcel-delivery-table">
    <table class="table">
        <thead>

        </thead>
        <tbody>
        <?php foreach($value['time'] as $key => $time ) { ?>
        <tr>
            <td class="text-left">
                <label for="delivery_option<?php echo $key; ?>">
                    <input type="radio"  class="input-radio" name="myparcel_option" id="delivery_option<?php echo $key; ?>" value="<?php echo $shipping_method_code. '-' .$time['start'] . '-' . $time['end']; ?>" action="<?php echo $action; ?>" <?php echo ($delivery_time_start == $time['start'] && $delivery_time_end == $time['end']) ? 'checked' : ''  ?> />
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
                    <!--- <div class="timeslottext">Test</div> -->
                </label>
            </td>
            <td class="text-right"><label class="text-strong" for="myparcel_additional_<?php echo $key; ?>"><?php echo $value['text_amount']; ?></label></td>
        </tr>
        <?php   }} ?>
        <?php } ?>
        </tbody>
    </table>
</div>
<?php break; }  } ?>
<?php } else { ?>
<div class="form-group" id="myparcel_pickup_location_select">
    <select class="form-control" name="myparcel_pickup_location" id="myparcel_pickup_location" action="<?php echo $action; ?>" style="font-size: 14px">
        <?php foreach($myparcel_delivery_option as $value) { ?>
        <option value="<?php echo $value['location']; ?>" <?php echo (($value['location'] == $pickup_detail['location']) ? 'selected' : '') ?> >
        <?php echo $value['location'] . ', ' . $value['street'] . ' ' . $value['number'] . ', ' . $value['city'] . '( ' . $value['distance'] . $value['distance_format'] . '  )'; ?>
        </option>
        <?php } ?>
    </select>
</div>
<div class="xdeltimeslots-table myparcel-pickup-table">
    <table class="table">
        <thead>

        </thead>
        <tbody>
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
                    <input type="radio" class="input-radio" id="pickup_option<?php echo $key; ?>" name="myparcel_option" action="<?php echo $action; ?>" value="<?php echo $shipping_method_code. '-' . $pickup_detail['location'] . '-' .$value['start'];  ?>" <?php echo ($pickup_time_start == $value['start']) ? 'checked' : ''  ?>/>
                    <?php echo $entry_pickup_from ;?> <?php echo $value['start']; ?>
                </label>
            </td>
            <td class="text-right"><label class="text-strong" for="myparcel_option<?php echo $key; ?>"><?php echo $value['price']['text_amount']; ?></label></td>
        </tr>
        <?php } ?>
        </tbody>
    </table>
</div>
<?php } ?>


<?php } ?>