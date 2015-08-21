class Dashing.Meter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))

    if $(@node).hasClass?('up_monitors')
      meter.attr("data-fgcolor", '#4ED04E')
    else if $(@node).hasClass?('down_monitors')
      meter.attr("data-fgcolor", 'red')
    else if $(@node).hasClass?('paused_monitors')
      meter.attr("data-fgcolor", 'black')

    meter.knob()
    meter.css('color', 'white')
