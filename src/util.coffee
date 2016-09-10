raw = (date, format) ->
  if typeof date == 'string'
    return moment(date, format)

  if Object.prototype.toString.call(date) == '[object Date]'
    return moment(date)

  if moment.isMoment(date)
    return date.clone()

parseDate = (date, format) ->
  format = if typeof format == 'string' then format else null
  parsed = raw date, format
  return parsed if parsed && parsed.isValid()
  null

parseTimeItem = (value) ->
  value = if typeof value == 'string' then parseInt(value, 10) else value
  if value < 10 then "0#{value}" else value.toString()

api =
  parseDate: parseDate
  parseTimeItem: parseTimeItem

module.exports = api