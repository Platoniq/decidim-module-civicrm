// = require select2
// = require_self


$(() => {
  const url = "/admin/civicrm/groups"
  const select2InputTags = (queryStr) => {
    var $input = $(queryStr)
      console.log("input", $input)

    var $select = $('<select class="'+ $input.attr('class') + '" multiple="multiple"><select>');
    if ($input.val() != "") {
      const values = $input.val().split(',');
      console.log("values", values, $input)
      values.forEach(function(item) {
        $select.append('<option value="' + item + '" selected="selected">' + item + '</option>')
      })
      ;
      // load text via ajax
      $.get(url, { ids: values }, (data) => {
        console.log("loaded", data)
        $select.val("");
        data.forEach((item) => {
         $select.append(new Option(item.text, item.id, true, true));
        });
        $select.trigger("change");
      }, "json");
    }
    $select.insertAfter($input);
    $input.hide();

    $select.change(function() {
      $input.val($select.val().join(","));
    });

    return $select;
  };

  $("input[name$='[authorization_handlers_options][civicrm_groups][groups]'").each((idx, input) => {
    select2InputTags(input).select2({
      ajax: {
        url: url,
        delay: 100,
        dataType: "json",
        processResults: (data) => {
          return {
            results: data
          }
        }
      },
      multiple: true,
      // templateResult: (item) => `${item.title}`,
      // escapeMarkup: (markup) => markup,
      // templateSelection: (item) => `${item.title}`,
      // minimumInputLength: 1,
      theme: "foundation"
    });
  });   
});
