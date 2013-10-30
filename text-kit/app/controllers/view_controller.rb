class ViewController < UIViewController
  attr_reader :text_storage

  def viewDidLoad
    super

    self.title = 'Controller'

    setup_constraints
  end

  def viewDidAppear(animated)
    @text_storage = HighlightingTextStorage.new
    text_storage.addLayoutManager(text_view.layoutManager)

    super
  end

  def setup_constraints
    Motion::Layout.new do |layout|
      layout.view       view
      layout.subviews   'text_view' => text_view
      layout.horizontal '|[text_view]|'
      layout.vertical   '|[text_view]|'
    end
  end

  def text_view
    @text_view ||= UITextView.new.tap do |text_view|
      text_view.autocorrectionType = UITextAutocorrectionTypeNo
      text_view.addGestureRecognizer(tap_recognizer)
    end
  end

  def tap_recognizer
    @tap_recognizer ||= UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handle_tap:')
  end

  def handle_tap(gesture_recognizer)
    text_view = gesture_recognizer.view

    layout_manager = text_view.layoutManager

    location = gesture_recognizer.locationInView(text_view)

    character_index = layout_manager.characterIndexForPoint(
      location,
      inTextContainer: text_view.textContainer,
      fractionOfDistanceBetweenInsertionPoints: nil)

    range_pointer = Pointer.new(NSRange.type)

    if character_index < text_storage.length
      value = text_storage.attributed_string.attribute(
        'Hashtag',
        atIndex: character_index,
        effectiveRange: range_pointer)

      p value
    end
  end
end
