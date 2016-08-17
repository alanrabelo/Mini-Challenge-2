
import UIKit

class ViewFichas: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    var indexPaths = [NSIndexPath]()

    let kRowsCount = 6
    
    var cellHeights = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, -700, view.frame.size.width, view.frame.size.height*100)
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.tableView.insertSubview(blurEffectView, atIndex: 0)
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellHeights.count
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      
      guard case let cell as CellFicha = cell else {
        return
      }
      
      cell.backgroundColor = UIColor.clearColor()
      
      if cellHeights[indexPath.row] == kCloseCellHeight {
        cell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        cell.selectedAnimation(true, animated: false, completion: nil)
      }
      
      cell.number = indexPath.row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath) as! CellFicha
        
    //BOTAO DE FECHAR A CELULA INI
        cell.btnCloseCell.tag = indexPath.row
        if self.indexPaths.count <= indexPath.row {
            self.indexPaths.append(indexPath)
        }else{
            self.indexPaths[indexPath.row] = indexPath
        }
        cell.btnCloseCell.addTarget(self, action: #selector(ViewFichas.btnCloseCellAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    //BOTAO DE FECHAR A CELULA END
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
            
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                tableView.beginUpdates()
                tableView.endUpdates()
                }, completion: nil)
            
            
            let heightSize = cell.center.y - sizeMov(indexPath.row)

            tableView.setContentOffset(CGPointMake(0, heightSize), animated: true)
        }
        
    }
    
    func btnCloseCellAction(sender: UIButton) {
        let cell = tableView.cellForRowAtIndexPath(indexPaths[sender.tag]) as! CellFicha
        
        if cell.isAnimating() {
            return
        }
        
        cellHeights[sender.tag] = kCloseCellHeight
        cell.selectedAnimation(false, animated: true, completion: nil)
        let duration = 0.8
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            }, completion: nil)
    }
    
    func sizeMov(row: Int) -> CGFloat {
        let window = UIApplication.sharedApplication().keyWindow
        
        let size35 = [305.0, 308.0, 305.0];
        let size4 = [320.0, 308.0, 325.0];
        let size47 = [350.0, 308.0, 425.0];
        let size52 = [390.0, 308.0, 490.0];
        
        let sizeScreen: Array<Double>
        
        switch Int((window?.frame.height)!) {
        case 568:
            sizeScreen = size4;
        case 667:
            sizeScreen = size47;
        case 736:
            sizeScreen = size52;
        default:
            sizeScreen = size35;
        }
        
        switch row {
        case 0:
            return CGFloat(sizeScreen[1])
        case cellHeights.count-1:
            return CGFloat(sizeScreen[2])
        default:
            return CGFloat(sizeScreen[0])
        }
    }
    
}
