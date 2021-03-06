truncate = (src, n=1000, depth=4) ->
  nn = 0
  seen = []

  fn = (src, dd=0) ->
    if typeof src != 'object'
      return src

    if seen.indexOf(src) >= 0
      return '[Circular]'
    seen.push(src)

    if dd >= depth
      return '[Truncated]'

    dst = {}
    for key of src
      if Object.prototype.hasOwnProperty.call(src, key)
        nn++
        if nn >= n
          break
        # Ignore browser specific exceptions trying to read key (#79).
        try
          val = src[key]
        catch
          continue
        dst[key] = fn(val, dd+1)

    return dst

  return fn(src)


jsonify = (notice) ->
  notice.params = truncate(notice.params)
  notice.environment = truncate(notice.environment)
  notice.session = truncate(notice.session)
  return JSON.stringify(notice)


module.exports = jsonify
