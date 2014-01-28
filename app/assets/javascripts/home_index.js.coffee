labelBarChart = (r, bc, labels, attrs) ->
  for bar, i in bc.bars
    gutter_y = bar.w * 0.5
    label_x = bar.x - bar.w-10
    label_y = bar.y
    label_text = labels[i]
    label_attr =  fill:  "#000", font: "9px sans-serif", "text-anchor":"end"
    r.text(label_x, label_y, label_text).attr label_attr


$(document).ready ->
  r = Raphael  document.getElementById("chart"), 400, 480
  fin = ->
    @flag = r.popup(@bar.x, @bar.y, @bar.value || "0").insertBefore(this)
  fout = -> 
    @flag.animate 
      opacity: 0,
      300, 
      ->
        this.remove
  chart = eval "[#{$('#dataholder').data('chart') }]"
  titles = $('#dataholder').data('title').split ','
  values =eval "[#{$('#dataholder').data('value') }]"
  r.piechart 190, 350, 50, chart,  legend: ["%%.%% - 中心城区", "%%.%% - 新城区"]
  bc = r.hbarchart(140, 20, 250, 300, values, gutter: '5%' ).attr( fill: "#248bca").hover(fin, fout)
  labelBarChart r, bc, titles,  fill:  "#2f69bf", font: "16px sans-serif" 
