// Extended disable function
jQuery.fn.extend({
    disable: function(state) {
        return this.each(function() {
            var $this = $(this);
            if($this.is("input, button, textarea, select"))
              this.disabled = state;
            else
              $this.toggleClass("disabled", state);
        });
    }
});

function remove_options(type) {
  $(".removable").val("1");
  $(".option_fields").hide();
  $("#question_type").val(type)
  if (type == "text") {
    document.getElementById("add-button").onclick();
    $(".correct-field").attr("checked", true);
    $(".correct-field").val("1");
    $(".correct-field").hide();
    $(".add-button").hide();
    $(".del-button").hide();
  }
  else {
    $(".add-button").show();
    $(".del-button").show();
  }
}

function if_text(element) {
  element.disabled = true;
}
