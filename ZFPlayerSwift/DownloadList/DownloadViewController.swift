//
//  DownloadViewController.swift
//  ZFPlayerSwift
//
//  Created by Radwa Khaled on 12/24/19.
//

import UIKit

class DownloadViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Params
    let DownloadManager = ZFDownloadManager.shared()
    var downloadObjectArr: [NSMutableArray]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -49, right: 0)
        tableView.rowHeight = 70
        DownloadManager!.downloadDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           initData()
       }
    
    func initData() {
        DownloadManager!.startLoad()
        let downladed = DownloadManager?.finishedlist
        let downloading = DownloadManager?.downinglist
        self.downloadObjectArr = []
        self.downloadObjectArr.append(downloading!)
        self.downloadObjectArr.append(downladed!)
        
        
        tableView.reloadData()
    }
       
    
    @IBAction func pauseAll(_ sender: UIBarButtonItem) {
           DownloadManager?.pauseAllDownloads()
       }
       @IBAction func startAll(_ sender: UIBarButtonItem) {
           DownloadManager?.startAllDownloads()
       }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if downloadObjectArr != nil {
            let sectionArray = downloadObjectArr[section]
            return (sectionArray as AnyObject).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "downloadedCell") as! ZFDownloadedCell
            let fileInfo:ZFFileModel = self.downloadObjectArr[indexPath.section][indexPath.row] as! ZFFileModel
            
            cell.setFileInfo(fileInfo: fileInfo) //fileInfo = fileInfo
            return cell
        }else if (indexPath.section == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "downloadingCell") as! ZFDownloadingCell
            let request : ZFHttpRequest = self.downloadObjectArr[indexPath.section][indexPath.row] as! ZFHttpRequest
            //if (request == nil) { return UITableViewCell() }
            
            let fileInfo = request.userInfo["File"] as? ZFFileModel
            weak var weakSelf = self
            cell.btnClickBlock = {
                weakSelf?.initData()
            }
            
            // 下载模型赋值 //Download model assignment
            cell.setFileInfo(fileInfo: fileInfo!)
            // 下载的request //Download request
            cell.request = request;
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {// downloading
            
        }else if (indexPath.section == 1) { // downloaded
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "VideoFullscreenViewController") as! VideoFullscreenViewController
            let fileInfo:ZFFileModel = self.downloadObjectArr[indexPath.section][indexPath.row] as! ZFFileModel
            vc.urlName = fileInfo.fileName
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "downloading"
        }else {
            return "Download completed"
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let fileInfo:ZFFileModel = self.downloadObjectArr[indexPath.section][indexPath.row] as! ZFFileModel
            DownloadManager?.deleteFinishFile(fileInfo)
        }else if indexPath.section == 0 {
            
            let request:ZFHttpRequest = self.downloadObjectArr[indexPath.section][indexPath.row] as! ZFHttpRequest
            DownloadManager?.delete(request)
        }
        
        tableView.deleteRows(at: [indexPath], with: .bottom)
        
    }
}

extension DownloadViewController:ZFDownloadDelegate {
    
    func startDownload(_ request: ZFHttpRequest!) {
        print("start download!")
    }
    
    func updateCellProgress(_ request: ZFHttpRequest!) {
        let fileInfo = request.userInfo["File"] as? ZFFileModel
        performSelector(onMainThread: #selector(updateCell(onMainThread:)), with: fileInfo, waitUntilDone: true)
    }
    
    func finishedDownload(_ request: ZFHttpRequest!) {
        
        initData()
    }
    
    // Update download progress
    @objc func updateCell(onMainThread fileInfo: ZFFileModel?) {
       
        guard downloadObjectArr != nil else {
            print("downloadObjectArr is nilllllll")
            return
        }
        
        for i in 0..<downloadObjectArr[0].count {
            if let t = (downloadObjectArr[0][i] as! ZFHttpRequest).userInfo["File"] as? ZFFileModel {
                if t.fileURL.isEqual(fileInfo?.fileURL) {
                    
                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = tableView.cellForRow(at: indexPath) as! ZFDownloadingCell
                    cell.setFileInfo(fileInfo: fileInfo!)
                    break
                }
            }
            
        }
    }
    
}
