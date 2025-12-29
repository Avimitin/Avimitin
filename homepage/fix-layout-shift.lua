local first_image_seen = false

function Image(elem)
  -- Add loading="lazy" only if it's not the first image
  if first_image_seen then
    elem.attributes.loading = "lazy"
  else
    first_image_seen = true
    -- Ensure the first image (LCP) is eager loaded
    elem.attributes.loading = "eager"
  end

  -- If width and height are already set, skip
  if elem.attributes.width and elem.attributes.height then
    return elem
  end

  local src = elem.src
  -- Remove leading ./ if present for command
  local path = src
  if path:sub(1,2) == "./" then
    path = path:sub(3)
  end

  -- Calculate dimensions using identify
  local handle = io.popen("identify -format '%w %h' " .. path)
  local result = handle:read("*a")
  handle:close()

  local width, height = result:match("(%d+) (%d+)")

  if width and height then
    elem.attributes.width = width
    elem.attributes.height = height
  end

  return elem
end
