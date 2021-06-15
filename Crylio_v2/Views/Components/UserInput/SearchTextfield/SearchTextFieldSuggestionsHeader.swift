//
//  SearchTextFieldSuggestionsHeader.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 26/05/2021.
//

import UIKit

class SearchTextFieldSuggestionsHeader: UIView {
    
    lazy var title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        title.font = .systemFont(ofSize: 13)
        title.textColor = AppColors.label.secondary
        
        addSubview(title)
    }

}



// MARK: - Constraints

extension SearchTextFieldSuggestionsHeader {
    
    override func updateConstraints() {
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13).priority(999)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().priority(999)
            make.height.equalTo(16)
        }
        
        super.updateConstraints()
    }
}
