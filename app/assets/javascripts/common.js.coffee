$.extend
  queryParams: (query)->
    query ||= document.location.search
    query.replace(/(^\?)/, '').split('&').map(((token)->
      pair = token.split('=')
      this[pair[0]] = decodeURIComponent(pair[1]) if pair[0] && pair[0].length
      this
    ).bind({}))[0]