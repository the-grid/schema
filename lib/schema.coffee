isSubtypeOf = (type, checkType) ->
  if typeof type is 'object'
    type = type.type

  # TODO: Parse from The Grid JSON Schema
  return true if checkType is 'block'
  return true if type is checkType
  if checkType is 'textual'
    return true if type in ['text', 'code', 'quote']
    return isSubtypeOf type, 'headline'
  if checkType is 'media'
    return type in ['image', 'video', 'audio', 'article', 'location', 'quote']
  if checkType is 'headline'
    return type in ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']
  if checkType is 'data'
    return type in ['list', 'table']
  false

normalizeMetadata = (block, item) ->
  block.metadata = {} unless block.metadata
  if item?.id
    block.metadata.source = item.id unless block.metadata.source

  # Author handling
  if typeof block.metadata.author is 'string'
    block.metadata.author = [
      name: block.metadata.author
    ]
  block.metadata.author = [] unless block.metadata.author
  if block.metadata.author.length and block.metadata.author_url
    block.metadata.author[0].url = block.metadata.author_url
  if block.metadata.author.length and block.metadata.author_image
    block.metadata.author[0].avatar =
      src: block.metadata.author_image

  # Publisher handling
  if typeof block.metadata.publisher is 'string'
    block.metadata.publisher =
      name: block.metadata.publisher
  block.metadata.publisher = {} unless block.metadata.publisher

  delete block.metadata.author_url
  delete block.metadata.author_image

  delete block.metadata.author unless block.metadata.author.length

  block

normalizeMediaBlock = (block, item) ->
  # Cover image normalization
  block.cover = {} unless block.cover
  block.cover.src = block.src if block.src and not block.cover.src?
  block.cover.width = block.width if block.width
  block.cover.height = block.height if block.height
  block.cover.colors = block.colors if block.colors
  block.cover.faces = block.faces if block.faces
  block.cover.orientation = block.orientation if block.orientation
  block.cover.ratio = block.ratio if block.ratio

  # Video normalization
  if typeof block.video is 'string'
    block.video =
      src: block.video
  block.video = {} unless block.video
  block.video.duration = block.duration if block.duration

  # Geographical information
  block.geo = {} unless block.geo
  block.geo.lat = block.lat if block.lat
  block.geo.lon = block.lon if block.lon

  # Clean up old measurement data
  delete block.src
  delete block.width
  delete block.height
  delete block.colors
  delete block.faces
  delete block.orientation
  delete block.ratio
  delete block.duration
  delete block.lat
  delete block.lon

  # Delete empty objects
  delete block.geo unless Object.keys(block.geo).length
  delete block.cover unless Object.keys(block.cover).length
  delete block.video unless Object.keys(block.video).length

  normalizeMetadata block, item

module.exports =
  isSubtypeOf: isSubtypeOf
  normalizeBlock: (block, item) ->
    if isSubtypeOf block.type, 'media'
      return normalizeMediaBlock block, item
    normalizeMetadata block, item
