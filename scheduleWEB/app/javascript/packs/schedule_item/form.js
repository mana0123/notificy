$(function() {
  // 初期ロード
  $(document).ready(function() {

    // 初期値によりフォーム表示を更新する
    $('.date_field').each(function(index, element){
      roop_type_status($(element).children('.date_field_item_middle'));
      month_roop_status($(element).children('.date_field_item_middle'));
      date_type_status($(element));
    });
    remove_btn_display();
  });

  // 「通知日を追加」を押下
  $('#date-add').click(function(){
    var $add_field = $('.date_field:last').clone(true);

    // name,id,for属性のインデックスを+1する
    var index = parseInt($add_field.children('.date_field_item_left').children('input:first').attr('name').match(/[0-9]/)[0]);

    var prefix_before = "dates["+ index +"]"
    var prefix_after = "dates["+ (index+1) +"]"

    $add_field.find(`[name^=\'${prefix_before}\']`).each(function(i, element){
      var name = $(element).attr('name').replace(prefix_before, prefix_after);
      $(element).attr('name', name);
    });

    $add_field.find(`[id^=\'${prefix_before}\']`).each(function(i, element){
      var id = $(element).attr('id').replace(prefix_before, prefix_after);
      $(element).attr('id', id);
    });

    $add_field.find(`[for^=\'${prefix_before}\']`).each(function(i, element){
      var str = $(element).attr('for').replace(prefix_before, prefix_after);
      $(element).attr('for', str);
    });

    // セレクトボックスの値が引き継がれない（初期値）になるため、
    // 各入力欄の表示状態を初期値で更新する。
    roop_type_status($add_field.children('.date_field_item_middle'));
    month_roop_status($add_field.children('.date_field_item_middle'));
    date_type_status($add_field);

    // 一番下に入力欄を追加する
    $add_field.insertAfter($('.date_field:last'));
    remove_btn_display();
  });

  $('.date-remove').click(function(){
    $(this).parents('.date_field').remove();
    remove_btn_display();
  });

  // 「固定値」または「繰り返し」を選択
  $('.select_date_type').change(function(){
    date_type_status($(this).parents('.date_field'));
  });

  // 「繰り返し」のタイプを選択
  $('.select_rooped_type').change(function(){
    roop_type_status($(this).parents('.date_field_item_middle'));
  });

  // 「毎月」の場合のタイプを選択
  $('.rooped_month_type input').click(function(){
    month_roop_status($(this).parents('.date_field_item_middle'));
  });

  //
  $('#schedule_form').submit(function(){
    // 画面表示されていないデータはdisabledにして、送信しないようにする
    $('.date_field_item_middle').find('input[style="display: none;"],select[style="display: none;"]').prop("disabled", true);
    $('.date_field_item_middle').find('span[style="display: none;"],div[style="display: none;"]').find('input,select').prop("disabled", true);
  });

  function date_type_status($date_field){
    var active = $date_field.find('.select_date_type:checked').val();
    var $date_field_item_middle = $date_field.children('.date_field_item_middle');

    $date_field_item_middle.children().show();
    if(active == 'fixed'){
      // 「固定日」を選択した場合
      $date_field_item_middle.children(".select_rooped_type,.select_week,select[name*=year],select[name*=month],select[name*=day],.rooped_month_type,span:contains('/')").hide();
    } else if(active == 'rooped'){
      // 「繰り返し」を選択した場合
      roop_type_status($date_field_item_middle)
    }
  };

  function roop_type_status($date_field_item_middle){
    var active = $date_field_item_middle.children('.select_rooped_type').val();
    var $rooped_month_type = $date_field_item_middle.children('.rooped_month_type');
    $date_field_item_middle.children().show();
    $date_field_item_middle.children('input[type=date]').hide();
    if(active == '1'){
      // 「毎年」の場合
      $rooped_month_type.hide();
      $date_field_item_middle.children('.select_week').hide();
    } else if(active == '2'){
    // 「毎月」の場合
      $rooped_month_type.show();
      $date_field_item_middle.children('select[name*=month]').hide();

      month_roop_status($date_field_item_middle)
    } else if(active == '3'){
      // 「毎週」の場合
      $rooped_month_type.hide();
      $date_field_item_middle.children('select[name*=month],select[name*=day]').hide();
      $date_field_item_middle.find('select[name*=dainan]').hide();
    } else if(active == '4'){
     // 「毎日」の場合
      $rooped_month_type.hide();
      $date_field_item_middle.find('.select_week').hide();
      $date_field_item_middle.children('select[name*=month],select[name*=day]').hide();
    } else if(active == '5'){
      // 「毎時」の場合
      $rooped_month_type.hide();
      $date_field_item_middle.find('.select_week').hide();
      $date_field_item_middle.children("select[name*=month],select[name*=day],select[name*=hour],span:contains('/')").hide();
    }
  }

  function month_roop_status($date_field_item_middle){
    var active = $date_field_item_middle.children('.rooped_month_type').children('input:checked').val();
    if(active == 'date'){
      // 「日付」を選択した場合
      $date_field_item_middle.children('select[name*=day]').show();
      $date_field_item_middle.children('.select_week').hide();
    } else {
      // 「曜日」を選択した場合
      $date_field_item_middle.children('select[name*=day]').hide();
      $date_field_item_middle.children('.select_week').show();
    }
  };

  function remove_btn_display(){
    if($('.date_field').length == 1){
      $('.date-remove').hide();
    } else {
      $('.date-remove').show();
    }
  };

});


