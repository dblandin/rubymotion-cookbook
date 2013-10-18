class HighlightingTextStorage < NSTextStorage
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
    regex = NSRegularExpression.regularExpressionWithPattern(
      "i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+",
      options: 0,
      error: nil)

    paragraph_range = string.paragraphRangeForRange(editedRange)
    removeAttribute(NSForegroundColorAttributeName, range: paragraph_range)

    regex.enumerateMatchesInString(
      string,
      options: 0,
      range: paragraph_range,
      usingBlock: match_block)

    super
  end

  def match_block
    -> (result, flags, stop) do
      match = string.substringWithRange(result.range)

      addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor, range: result.range)
      addAttribute('Hashtag', value: match, range: result.range)
    end
  end
end
