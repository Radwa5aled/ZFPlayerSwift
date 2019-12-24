//
//  ZFDownloadedCell.swift


import UIKit

class ZFDownloadedCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    
    
    var fileInfo:ZFFileModel! //Download Information Model
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFileInfo(fileInfo:ZFFileModel) {
        self.fileInfo = fileInfo
        let totalSize = ZFCommonHelper.getFileSizeString(fileInfo.fileSize)
        self.fileNameLabel.text = fileInfo.lessonName
        sizeLabel.text = totalSize
        imgFile.image = fileInfo.fileimage
    }
    
}
