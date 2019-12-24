//
//  ZFDownloadingCell.swift


import UIKit

class ZFDownloadingCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var downloadBtn: UIButton!
    
  typealias ZFBtnClickBlock = () -> Void
    
 //Download button click callback block
    var btnClickBlock: ZFBtnClickBlock!
   //Download Information Model
    var fileInfo:ZFFileModel!
//Request from this file
    var request : ZFHttpRequest!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickDownload(_ sender: UIButton) {
    
        sender.isUserInteractionEnabled = false
        let downFile:ZFFileModel = self.fileInfo
        let fileDownManage:ZFDownloadManager = ZFDownloadManager.shared()
        if downFile.downloadState == ZFDownLoadState.downloading {
            self.downloadBtn.isSelected = true
            fileDownManage.stop(self.request)
            
        }else {
             self.downloadBtn.isSelected = false
            fileDownManage.resumeRequest(self.request)
        }
        
        if (self.btnClickBlock != nil) {
            self.btnClickBlock()
        }
        
          sender.isUserInteractionEnabled = true
        
    }
    
    func setFileInfo(fileInfo:ZFFileModel) {
        self.fileInfo = fileInfo
        self.fileNameLabel.text = fileInfo.lessonName
        if Int(fileInfo.fileSize ?? "" ) == nil &&  !(fileInfo.downloadState == .downloading) {
            progressLabel.text = ""
            if fileInfo.downloadState == .stopDownload {
                speedLabel.text = "Paused"
            } else if fileInfo.downloadState == .willDownload {
                downloadBtn.isSelected = true
                speedLabel.text = "Waiting for download"
            }
            self.progress.progress = 0.0
            return
        }
        
        let currentSize = ZFCommonHelper.getFileSizeString(fileInfo.fileReceivedSize)
        let totalSize = ZFCommonHelper.getFileSizeString(fileInfo.fileSize)

        let progress:Float = (Float(fileInfo.fileReceivedSize ?? "" ) ?? 0.0) / (Float(fileInfo.fileSize ?? "") ?? 0.0)
        
        self.progressLabel.text = String(format: "%@ / %@ (%.2f%%)", currentSize!, totalSize!, progress * 100)
        self.progress.progress = progress
        
        if (fileInfo.speed != nil) {
            let speed = "\(String(describing: fileInfo.speed!)) Remaining: \(String(describing: fileInfo.remainingTime!))"
             self.speedLabel.text = speed
        }else {
            self.speedLabel.text = "retrieving"
        }
        
        if (fileInfo.downloadState == .downloading) { //File is downloading //文件正在下载
               self.downloadBtn.isSelected = false
        } else if (fileInfo.downloadState == .stopDownload && !fileInfo.error) {
               self.downloadBtn.isSelected = true
               self.speedLabel.text = "Paused"
        }else if (fileInfo.downloadState == .willDownload && !fileInfo.error) {
               self.downloadBtn.isSelected = true
               self.speedLabel.text = "Waiting for download"
           } else if (fileInfo.error) {
            self.downloadBtn.isSelected = true
               self.speedLabel.text = "error"
           }
        
    }
    
}
