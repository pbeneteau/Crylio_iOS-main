//
//  SearchTextField.swift
//  SearchTextField
//
//  Created by Alejandro Pasccon on 4/20/16.
//  Copyright © 2016 Alejandro Pasccon. All rights reserved.
//

import UIKit


class BaseTextField: UITextField, UITextFieldDelegate {
    
    lazy var selectionView = UILabel()
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        addTargetFunctions()
        addObservers()
        
        setSelectionViewAlpha(0, animated: false)
        
        selectionView.backgroundColor = .systemBlue
                
        addSubview(selectionView)
        bringSubviewToFront(selectionView)
    }
    
    private func addTargetFunctions() {
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldDidEndEditingOnExit(_:)), for: .editingDidEndOnExit)
        self.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
    }
    
    @objc func textFieldDidEndEditingOnExit(_ textField: UITextField) {
        setSelectionViewAlpha(0, animated: true)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        setSelectionViewAlpha(1, animated: true)
    }

    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        setSelectionViewAlpha(0, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
    }
    
    @objc func keyboardDidChangeFrame(_ notification: Notification) {
    }
    
    private func setSelectionViewAlpha(_ alpha: CGFloat, animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.selectionView.alpha = alpha
            })
        } else {
            selectionView.alpha = alpha
        }
    }
    
    func setSelectionValid(_ valid: Bool) {
        
        if valid {
            selectionView.backgroundColor = .systemBlue
        } else {
            selectionView.backgroundColor = .red
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
}


class SearchTextField: BaseTextField {
    
    ////////////////////////////////////////////////////////////////////////
    // interface
    
    /// Maximum number of results to be shown in the suggestions list
    var maxNumberOfResults = 0
    
    /// Maximum height of the results list
    var maxResultsListHeight = 0
    
    /// Indicate if this field has been interacted with yet
    var interactedWith = false
    
    /// Indicate if keyboard is showing or not
    var keyboardIsShowing = false
    
    /// How long to wait before deciding typing has stopped
    var typingStoppedDelay = 0.8
    
    /// Set your custom visual theme, or just choose between pre-defined SearchTextFieldTheme.lightTheme() and SearchTextFieldTheme.darkTheme() themes
    var theme = SearchTextFieldTheme.lightTheme() {
        didSet {
            tableView?.reloadData()
            
            if let placeholderColor = theme.placeholderColor {
                if let placeholderString = placeholder {
                    self.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
                }
                
                self.placeholderLabel?.textColor = placeholderColor
            }
            
            if let hightlightedFont = self.highlightAttributes[.font] as? UIFont {
                self.highlightAttributes[.font] = hightlightedFont.withSize(self.theme.font.pointSize)
            }
        }
    }
    
    /// Show the suggestions list without filter when the text field is focused
    var startVisible = false
    
    /// Show the suggestions list without filter even if the text field is not focused
    var startVisibleWithoutInteraction = false {
        didSet {
            if startVisibleWithoutInteraction {
                textFieldDidChange(self)
            }
        }
    }
    
    /// Set an array of SearchTextFieldItem's to be used for suggestions
    func filterItems(_ items: [SearchTextFieldItem]) {
        filterDataSource = items
    }
    
    /// Set an array of strings to be used for suggestions
    func filterStrings(_ strings: [String]) {
        var items = [SearchTextFieldItem]()
        
        for value in strings {
            items.append(SearchTextFieldItem(title: value))
        }
        
        filterItems(items)
    }
    
    /// Closure to handle when the user pick an item
    var itemSelectionHandler: SearchTextFieldItemHandler?
    
    /// Closure to handle when the user stops typing
    var userStoppedTypingHandler: (() -> Void)?
    
    /// Set your custom set of attributes in order to highlight the string found in each item
    var highlightAttributes: [NSAttributedString.Key: AnyObject] = [.font: UIFont.boldSystemFont(ofSize: 10)]
    
    /// Start showing the default loading indicator, useful for searches that take some time.
    func showLoadingIndicator() {
        self.rightViewMode = .always
        indicator.startAnimating()
    }
    
    /// Force the results list to adapt to RTL languages
    var forceRightToLeft = false
    
    /// Hide the default loading indicator
    func stopLoadingIndicator() {
        self.rightViewMode = .never
        indicator.stopAnimating()
    }
    
    /// When InlineMode is true, the suggestions appear in the same line than the entered string. It's useful for email domains suggestion for example.
    var inlineMode: Bool = false {
        didSet {
            if inlineMode == true {
                autocorrectionType = .no
                spellCheckingType = .no
            }
        }
    }
    
    /// Only valid when InlineMode is true. The suggestions appear after typing the provided string (or even better a character like '@')
    var startFilteringAfter: String?
    
    /// Min number of characters to start filtering
    var minCharactersNumberToStartFiltering: Int = 0
    
    /// Force no filtering (display the entire filtered data source)
    var forceNoFiltering: Bool = false
    
    /// If startFilteringAfter is set, and startSuggestingImmediately is true, the list of suggestions appear immediately
    var startSuggestingImmediately = false
    
    /// Allow to decide the comparision options
    var comparisonOptions: NSString.CompareOptions = [.caseInsensitive]
    
    /// Set the results list's header
    var resultsListHeader: UIView?
    
    // Move the table around to customize for your layout
    var tableXOffset: CGFloat = 0.0
    var tableYOffset: CGFloat = 0.0
    var tableCornerRadius: CGFloat = 7
    var tableBottomMargin: CGFloat = 10.0
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    
    fileprivate var tableView: UITableView?
    fileprivate var direction: Direction = .down
    fileprivate var fontConversionRate: CGFloat = 0.7
    fileprivate var keyboardFrame: CGRect?
    fileprivate var timer: Timer? = nil
    fileprivate var placeholderLabel: UILabel?
    fileprivate static let cellIdentifier = "APSearchTextFieldCell"
    fileprivate let indicator = UIActivityIndicatorView(style: .medium)
    fileprivate var maxTableViewSize: CGFloat = 0
    
    fileprivate var filteredResults = [SearchTextFieldItem]()
    fileprivate var filterDataSource = [SearchTextFieldItem]() {
        didSet {
            filter(forceShowAll: forceNoFiltering)
            buildSearchTableView()
            
            if startVisibleWithoutInteraction {
                textFieldDidChange(self)
            }
        }
    }
    
    fileprivate var currentInlineItem = ""
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if inlineMode {
            buildPlaceholderLabel()
        } else {
            buildSearchTableView()
        }
        
        // Create the loading indicator
        indicator.hidesWhenStopped = true
        self.rightView = indicator
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightFrame = super.rightViewRect(forBounds: bounds)
        rightFrame.origin.x -= 5
        return rightFrame
    }
    
    // Create the filter table and shadow view
    fileprivate func buildSearchTableView() {
        guard let tableView = tableView else {
            self.tableView = UITableView(frame: CGRect.zero)
            buildSearchTableView()
            return
        }
        
        tableView.backgroundColor = .clear
        tableView.layer.masksToBounds = false
        tableView.layer.borderWidth = theme.borderWidth > 0 ? theme.borderWidth : 0.5
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableHeaderView = resultsListHeader
        tableView.separatorStyle = .none
        tableView.register(SearchTextFieldTableViewCell.self, forCellReuseIdentifier: SearchTextFieldTableViewCell.reuseId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)
        
        if forceRightToLeft {
            tableView.semanticContentAttribute = .forceRightToLeft
        }
        
        backgroundColor = .clear
        
        addBackground()
        
        self.window?.addSubview(tableView)
        
        redrawSearchTableView()
    }
    
    fileprivate func buildPlaceholderLabel() {
        
        var newRect = self.placeholderRect(forBounds: self.bounds)
        var caretRect = self.caretRect(for: self.beginningOfDocument)
        let textRect = self.textRect(forBounds: self.bounds)
        
        if let range = textRange(from: beginningOfDocument, to: endOfDocument) {
            caretRect = self.firstRect(for: range)
        }
        
        newRect.origin.x = caretRect.origin.x + caretRect.size.width + textRect.origin.x
        newRect.size.width = newRect.size.width - newRect.origin.x
        
        if let placeholderLabel = placeholderLabel {
            placeholderLabel.font = self.font
            placeholderLabel.frame = newRect
        } else {
            placeholderLabel = UILabel(frame: newRect)
            placeholderLabel?.font = self.font
            placeholderLabel?.backgroundColor = UIColor.clear
            placeholderLabel?.lineBreakMode = .byClipping
            
            if let placeholderColor = self.attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
                placeholderLabel?.textColor = placeholderColor
            } else {
                placeholderLabel?.textColor = UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            }
            
            self.addSubview(placeholderLabel!)
        }
    }
    
    // Re-set frames and theme colors
    fileprivate func redrawSearchTableView() {
        if inlineMode {
            tableView?.isHidden = true
            return
        }
        
        if let tableView = tableView {
            guard let frame = self.superview?.convert(self.frame, to: nil) else { return }
            
            //TableViews use estimated cell heights to calculate content size until they
            //  are on-screen. We must set this to the theme cell height to avoid getting an
            //  incorrect contentSize when we have specified non-standard fonts and/or
            //  cellHeights in the theme. We do it here to ensure updates to these settings
            //  are recognized if changed after the tableView is created
            tableView.estimatedRowHeight = theme.cellHeight
            if self.direction == .down {
                
                var tableHeight: CGFloat = 0
                if keyboardIsShowing, let keyboardHeight = keyboardFrame?.size.height {
                    tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height - keyboardHeight))+7
                } else {
                    tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height))+7
                }
                
                if maxResultsListHeight > 0 {
                    tableHeight = min(tableHeight, CGFloat(maxResultsListHeight))+7
                }
                
                // Set a bottom margin of 10p
                if tableHeight < tableView.contentSize.height {
                    tableHeight -= tableBottomMargin
                }
                
                var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
                tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
                tableViewFrame.origin.x += 2 + tableXOffset
                tableViewFrame.origin.y += frame.size.height + 2 + tableYOffset
                self.tableView?.frame.origin = tableViewFrame.origin // Avoid animating from (0, 0) when displaying at launch
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.tableView?.frame = tableViewFrame
                    })
                }
                
                
            } else {
                let tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - theme.cellHeight))+7
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.tableView?.frame = CGRect(x: frame.origin.x + 2, y: (frame.origin.y - tableHeight), width: frame.size.width - 4, height: tableHeight)
                    })
                }
            }
            
            superview?.bringSubviewToFront(tableView)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.layer.borderColor = theme.borderColor.cgColor
            tableView.layer.cornerRadius = tableCornerRadius
            tableView.separatorColor = theme.separatorColor
            tableView.backgroundColor = theme.bgColor
            
            addBackground()
            
            tableView.reloadData()
        }
    }
    
    // Handle keyboard events
    @objc override func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShowing && isEditing {
            keyboardIsShowing = true
            keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            interactedWith = true
            prepareDrawTableResult()
        }
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShowing {
            keyboardIsShowing = false
            direction = .down
            redrawSearchTableView()
        }
    }
    
    @objc override func keyboardDidChangeFrame(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self?.prepareDrawTableResult()
        }
    }
    
    @objc func typingDidStop() {
        self.userStoppedTypingHandler?()
    }
    
    // Handle text field changes
    @objc override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        
        if !inlineMode && tableView == nil {
            buildSearchTableView()
        }
        
        interactedWith = true
        
        // Detect pauses while typing
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: typingStoppedDelay, target: self, selector: #selector(SearchTextField.typingDidStop), userInfo: self, repeats: false)
        
        filter(forceShowAll: forceNoFiltering)
        prepareDrawTableResult()
        
        buildPlaceholderLabel()
    }
    
    @objc override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
                
        filter(forceShowAll: true)
        
        if (startVisible || startVisibleWithoutInteraction) && text!.isEmpty {
            clearResults()
            filter(forceShowAll: true)
        }
        placeholderLabel?.attributedText = nil
    }
    
    @objc override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditingOnExit(textField)
        
        clearResults()
        tableView?.reloadData()
        placeholderLabel?.attributedText = nil
    }
    
    @objc override func textFieldDidEndEditingOnExit(_ textField: UITextField) {
        super.textFieldDidEndEditingOnExit(textField)
                
        if let firstElement = filteredResults.first {
            if let itemSelectionHandler = self.itemSelectionHandler {
                itemSelectionHandler(filteredResults, 0)
            }
            else {
                if inlineMode, let filterAfter = startFilteringAfter {
                    let stringElements = self.text?.components(separatedBy: filterAfter)
                    
                    self.text = stringElements!.first! + filterAfter + firstElement.title
                } else {
                    self.text = firstElement.title
                }
            }
        }
        
    }
    
    func hideResultsList() {
        
        if let tableFrame:CGRect = tableView?.frame {
            let newFrame = CGRect(x: tableFrame.origin.x, y: tableFrame.origin.y, width: tableFrame.size.width, height: 0.0)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = newFrame
            })
            
        }
    }
    
    fileprivate func addBackground() {
        
        let bg = BackgroundBoxView()
        
        bg.backgroundColor = AppColors.background.primary
        bg.frame = self.tableView!.bounds
        
        self.tableView?.backgroundView = bg
    }
    
    fileprivate func filter(forceShowAll addAll: Bool) {
        clearResults()
        
        if text!.count < minCharactersNumberToStartFiltering {
            return
        }
        
        for i in 0 ..< filterDataSource.count {
            
            let item = filterDataSource[i]
            
            if !inlineMode {
                // Find text in title and subtitle
                let titleFilterRange = (item.title as NSString).range(of: text!, options: comparisonOptions)
                let subtitleFilterRange = item.subtitle != nil ? (item.subtitle! as NSString).range(of: text!, options: comparisonOptions) : NSMakeRange(NSNotFound, 0)
                
                if titleFilterRange.location != NSNotFound || subtitleFilterRange.location != NSNotFound || addAll {
                    item.attributedTitle = NSMutableAttributedString(string: item.title)
                    item.attributedSubtitle = NSMutableAttributedString(string: (item.subtitle != nil ? item.subtitle! : ""))
                    
                    item.attributedTitle!.setAttributes(highlightAttributes, range: titleFilterRange)
                    
                    if subtitleFilterRange.location != NSNotFound {
                        item.attributedSubtitle!.setAttributes(highlightAttributesForSubtitle(), range: subtitleFilterRange)
                    }
                    
                    filteredResults.append(item)
                }
            } else {
                var textToFilter = text!.lowercased()
                
                if inlineMode, let filterAfter = startFilteringAfter {
                    if let suffixToFilter = textToFilter.components(separatedBy: filterAfter).last, (suffixToFilter != "" || startSuggestingImmediately == true), textToFilter != suffixToFilter {
                        textToFilter = suffixToFilter
                    } else {
                        placeholderLabel?.text = ""
                        return
                    }
                }
                
                if item.title.lowercased().hasPrefix(textToFilter) {
                    let indexFrom = textToFilter.index(textToFilter.startIndex, offsetBy: textToFilter.count)
                    let itemSuffix = item.title[indexFrom...]
                    
                    item.attributedTitle = NSMutableAttributedString(string: String(itemSuffix))
                    filteredResults.append(item)
                }
            }
        }
        
        tableView?.reloadData()
        
        if inlineMode {
            handleInlineFiltering()
        }
    }
    
    // Clean filtered results
    fileprivate func clearResults() {
        
        filteredResults.removeAll()
        tableView?.removeFromSuperview()
    }
    
    // Look for Font attribute, and if it exists, adapt to the subtitle font size
    fileprivate func highlightAttributesForSubtitle() -> [NSAttributedString.Key: AnyObject] {
        
        var highlightAttributesForSubtitle = [NSAttributedString.Key: AnyObject]()
        
        for attr in highlightAttributes {
            if attr.0 == NSAttributedString.Key.font {
                let fontName = (attr.1 as! UIFont).fontName
                let pointSize = (attr.1 as! UIFont).pointSize * fontConversionRate
                highlightAttributesForSubtitle[attr.0] = UIFont(name: fontName, size: pointSize)
            } else {
                highlightAttributesForSubtitle[attr.0] = attr.1
            }
        }
        
        return highlightAttributesForSubtitle
    }
    
    // Handle inline behaviour
    func handleInlineFiltering() {
        
        if let text = self.text {
            if text == "" {
                self.placeholderLabel?.attributedText = nil
            } else {
                if let firstResult = filteredResults.first {
                    self.placeholderLabel?.attributedText = firstResult.attributedTitle
                } else {
                    self.placeholderLabel?.attributedText = nil
                }
            }
        }
    }
    
    // MARK: - Prepare for draw table result
    
    fileprivate func prepareDrawTableResult() {
        guard let frame = self.superview?.convert(self.frame, to: UIApplication.shared.keyWindow) else { return }
        if let keyboardFrame = keyboardFrame {
            var newFrame = frame
            newFrame.size.height += theme.cellHeight
            
            if keyboardFrame.intersects(newFrame) {
                direction = .up
            } else {
                direction = .down
            }
            
            redrawSearchTableView()
        } else {
            if self.center.y + theme.cellHeight > UIApplication.shared.keyWindow!.frame.size.height {
                direction = .up
            } else {
                direction = .down
            }
        }
    }
}

extension SearchTextField: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = !interactedWith || (filteredResults.count == 0)
        
        if maxNumberOfResults > 0 {
            return min(filteredResults.count, maxNumberOfResults)
        } else {
            return filteredResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTextFieldTableViewCell.reuseId, for: indexPath) as? SearchTextFieldTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchTextFieldTableViewCell.")
        }
        
        if indexPath.row == 0 {
            cell.selectionView.isHidden = false
            cell.titleLabel.textColor = .systemBlue
        }
        
        cell.content = (title: filteredResults[(indexPath as NSIndexPath).row].title, image: filteredResults[(indexPath as NSIndexPath).row].image ?? nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return theme.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemSelectionHandler == nil {
            self.text = filteredResults[(indexPath as NSIndexPath).row].title
        } else {
            let index = indexPath.row
            itemSelectionHandler!(filteredResults, index)
        }
        
        clearResults()
    }
    
}


// MARK: - Search Text Field Theme

struct SearchTextFieldTheme {
    
    var cellHeight: CGFloat
    var bgColor: UIColor
    var borderColor: UIColor
    var borderWidth : CGFloat = 0
    var separatorColor: UIColor
    var font: UIFont
    var fontColor: UIColor
    var subtitleFontColor: UIColor
    var placeholderColor: UIColor?
    
    init(cellHeight: CGFloat, bgColor:UIColor, borderColor: UIColor, separatorColor: UIColor, font: UIFont, fontColor: UIColor, subtitleFontColor: UIColor? = nil) {
        self.cellHeight = cellHeight
        self.borderColor = borderColor
        self.separatorColor = separatorColor
        self.bgColor = bgColor
        self.font = font
        self.fontColor = fontColor
        self.subtitleFontColor = subtitleFontColor ?? fontColor
    }
    
    static func lightTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 1, green: 1, blue: 1, alpha: 0.6), borderColor: UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: AppColors.label.primary)
    }
    
    static func darkTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6), borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: AppColors.label.primary)
    }
}

////////////////////////////////////////////////////////////////////////
// Filter Item

class SearchTextFieldItem {
    // Private vars
    fileprivate var attributedTitle: NSMutableAttributedString?
    fileprivate var attributedSubtitle: NSMutableAttributedString?
    
    // interface
    var title: String
    var subtitle: String?
    var image: UIImage?
    
    init(title: String, subtitle: String?, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    init(title: String) {
        self.title = title
    }
}

typealias SearchTextFieldItemHandler = (_ filteredResults: [SearchTextFieldItem], _ index: Int) -> Void

////////////////////////////////////////////////////////////////////////
// Suggestions List Direction

enum Direction {
    case down
    case up
}
