// = require select2
// = require_self

$(() => {
  /**
   * Used to override simple inputs in the resource permissions controller
   * Allows to use more than one group when configuring :civicrm_groups authorization handler
   * */
  const url_groups = "/admin/civicrm/groups";
  const url_participatory_spaces = "/admin/civicrm/groups/participatory_spaces"
  
  const select2InputTags = (queryStr) => {
    const $input = $(queryStr)

    const $select = $('<select class="'+ $input.attr('class') + '" multiple="multiple"><select>');
    if ($input.val() != "") {
      const values = $input.val().split(',');
      values.forEach((item) =>  {
        $select.append('<option value="' + item + '" selected="selected">' + item + '</option>')
      })
      ;
      // load text via ajax
      $.get(url_groups, { ids: values }, (data) => {
        $select.val("");
        $select.contents("option").remove()
        data.forEach((item) => {
         $select.append(new Option(item.text, item.id, true, true));
        });
        $select.trigger("change");
      }, "json");
    }
    $select.insertAfter($input);
    $input.hide();

    $select.change(() => {
      $input.val($select.val().join(","));
    });

    return $select;
  };

  $("input[name$='[authorization_handlers_options][civicrm_groups][groups]'").each((idx, input) => {
    select2InputTags(input).select2({
      ajax: {
        url: url_groups,
        delay: 100,
        dataType: "json",
        processResults: (data) => {
          return {
            results: data
          }
        }
      },
      multiple: true,
      theme: "foundation"
    });
  });   

  /**
   * Configure a conveninent multiselect to choose which participatory spaces should sync with civicrm groups
   * */
  const $spaces_selector = $("#civicrm-groups-participatory-spaces-selector").select2({
    ajax: {
      url: url_participatory_spaces,
      delay: 100,
      dataType: "json",
      processResults: (data) => {
        return {
          results: data
        }
      }
    },
    theme: "foundation"
  });

  const $submit = $("#civicrm-groups-participatory-spaces-submit");
  $spaces_selector.change(() => {
    $submit.attr("disabled", false);
  });

  $submit.on("click", () => {
    $submit.attr("disabled", true);
    $submit.addClass("hollow");
    $.post(window.location.href, {participatory_spaces: $spaces_selector.val(), _method: "PATCH"}, () =>{
      $submit.removeClass("hollow");
    });
  });
});
