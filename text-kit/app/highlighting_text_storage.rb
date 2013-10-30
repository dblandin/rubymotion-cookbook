class HighlightingTextStorage < NSTextStorage
  HASHTAG_REXGEX = '#(\\w+)'
  MENTION_REGEX  = '@(\\w+)'
  LOCATION_REGEX = '@@(\\w+)'

  attr_reader :attributed_string

  def init
    super.tap do |storage|
      storage.instance_variable_set('@attributed_string', NSMutableAttributedString.new)
    end
  end

  def string
    attributed_string.string
  end

  def attributesAtIndex(location, effectiveRange: range)
    attributed_string.attributesAtIndex(location, effectiveRange: range)
  end

  def replaceCharactersInRange(range, withString: string)
    attributed_string.replaceCharactersInRange(range, withString: string)

    edited(NSTextStorageEditedCharacters, range: range, changeInLength: string.length - range.length)
  end

  def setAttributes(attributes, range: range)
    attributed_string.setAttributes(attributes, range: range)

    edited(NSTextStorageEditedAttributes, range: range, changeInLength: 0)
  end

  def processEditing
    hashtag_expression = NSRegularExpression.regularExpressionWithPattern(
      HASHTAG_REXGEX,
      options: 0,
      error: nil)

    mention_expression = NSRegularExpression.regularExpressionWithPattern(
      MENTION_REGEX,
      options: 0,
      error: nil)

    location_expression = NSRegularExpression.regularExpressionWithPattern(
      LOCATION_REGEX,
      options: 0,
      error: nil)

    paragraph_range = string.paragraphRangeForRange(editedRange)
    removeAttribute(NSForegroundColorAttributeName, range: paragraph_range)

    hashtag_expression.enumerateMatchesInString(
      string,
      options: 0,
      range: paragraph_range,
      usingBlock: hashtag_match_block)

    mention_expression.enumerateMatchesInString(
      string,
      options: 0,
      range: paragraph_range,
      usingBlock: mention_match_block)

    location_expression.enumerateMatchesInString(
      string,
      options: 0,
      range: paragraph_range,
      usingBlock: location_match_block)

    super
  end

  def hashtag_match_block
    -> (result, flags, stop) do
      match = string.substringWithRange(result.range)

      addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor, range: result.range)
      addAttribute('Hashtag', value: match, range: result.range)
    end
  end

  def mention_match_block
    -> (result, flags, stop) do
      match = string.substringWithRange(result.range)

      addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor, range: result.range)
      addAttribute('Mention', value: match, range: result.range)
    end
  end

  def location_match_block
    -> (result, flags, stop) do
      match = string.substringWithRange(result.range)

      addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor, range: result.range)
      addAttribute('Location', value: match, range: result.range)
    end
  end
end
