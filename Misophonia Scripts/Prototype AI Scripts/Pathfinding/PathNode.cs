using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PathNode : MonoBehaviour
{
    public LayerMask layerM;                            //layermask to consider when raycasting, should only me node layer.

    public bool badNode;                                //set true if node is bad
    public bool refreshNode;                            //set true if node is to  be refreshed later
       
    public GameObject top;                              //storage of connected nodes goes here
    public GameObject topLeft;
    public GameObject topRight;
    public GameObject bot;
    public GameObject botLeft;
    public GameObject botRight;
    public GameObject left;
    public GameObject right;

    Collider2D refreshCol = null;                       //storage to reference refresh trigger

    float nodeDist;                                     //storage to contain unitSize
    int minConnection;                                  //storage to contain min num of connections

    GridMaster gM;                                      //storage for gridmaster

    //Pathfinding related storage; ignore
    [HideInInspector] public GameObject parentNode = null;
    [HideInInspector] public float f = 0;

    // Use this for initialization
    void Start ()
    {

	}
	
	// Update is called once per frame
	void Update ()
    {

	}

    /*
     * Fires off raycasts in 8 directions and saves the node if hit to appropriate storage for later reference
     * also checks if min. num of connections is met, else bad node
     */
    public void ConnectNode()
    {
        int connectCount = 0;
        RaycastHit2D hit;

        float diag = Mathf.Sqrt(nodeDist * nodeDist * 2); 

        //top
        hit = Physics2D.Raycast(transform.position, Vector2.up, nodeDist, layerM);
        //Debug.DrawRay(transform.position, new Vector3(0, 1, 0) * nodeDist, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            top = hit.collider.gameObject;
            ++connectCount;
        }

        //bot
        hit = Physics2D.Raycast(transform.position, Vector2.down, nodeDist, layerM);
        //Debug.DrawRay(transform.position, new Vector3(0, -1, 0) * nodeDist, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            bot = hit.collider.gameObject;
            ++connectCount;
        }

        //left
        hit = Physics2D.Raycast(transform.position, Vector2.left, nodeDist, layerM);
        //Debug.DrawRay(transform.position, new Vector3(-1, 0, 0) * nodeDist, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            left = hit.collider.gameObject;
            ++connectCount;
        }

        //right
        hit = Physics2D.Raycast(transform.position, Vector2.right, nodeDist, layerM);
        //Debug.DrawRay(transform.position, new Vector3(1, 0, 0) * nodeDist, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            right = hit.collider.gameObject;
            ++connectCount;
        }

        //topright
        hit = Physics2D.Raycast(transform.position, new Vector2(1,1), diag, layerM);
        //Debug.DrawRay(transform.position, new Vector3(1, 1, 0) * diag, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            topRight = hit.collider.gameObject;
            ++connectCount;
        }

        //topleft
        hit = Physics2D.Raycast(transform.position, new Vector2(-1, 1), diag, layerM);
        //Debug.DrawRay(transform.position, new Vector3(-1, 1, 0) * diag, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            topLeft = hit.collider.gameObject;
            ++connectCount;
        }

        //botleft
        hit = Physics2D.Raycast(transform.position, new Vector2(-1, -1), diag, layerM);
        //Debug.DrawRay(transform.position, new Vector3(-1, -1, 0) * diag, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            botLeft = hit.collider.gameObject;
            ++connectCount;
        }

        //botright
        hit = Physics2D.Raycast(transform.position, new Vector2(1, -1), diag, layerM);
        //Debug.DrawRay(transform.position, new Vector3(1, -1, 0) * diag, Color.green, Mathf.Infinity);

        if (hit.collider != null && hit.collider.gameObject.tag == "nodeCol")
        {
            botRight = hit.collider.gameObject;
            ++connectCount;
        }

        if (connectCount < minConnection) 
        {
            badNode = true;
            SetColor(Color.red);

            gM.nodeList.Remove(gameObject);
            gM.badNodeList.Add(gameObject);
        }
    }

    /*
     * if badnode, removes all connections and remove from main node list,
     * if not remove all connections to bad node and check if min connection requirements is met
     * if not met, set as bad node and remove from main node list.
     * 
     * can included to destroy node here
     */
    public void CheckBadNode()
    {
        if (badNode)
        {
            top = null;
            bot = null;
            left = null;
            right = null;
            topLeft = null;
            topRight = null;
            botLeft = null;
            botRight = null;

            gM.nodeList.Remove(gameObject);
            gM.badNodeList.Add(gameObject);
        }

        else
        {
            if (top != null && top.GetComponent<PathNode>().badNode)
            {
                top = null;
            }

            if (bot != null && bot.GetComponent<PathNode>().badNode)
            {
                bot = null;
            }

            if (left != null && left.GetComponent<PathNode>().badNode)
            {
                left = null;
            }

            if (right != null && right.GetComponent<PathNode>().badNode)
            {
                right = null;
            }

            if (topLeft != null && topLeft.GetComponent<PathNode>().badNode)
            {
                topLeft = null;
            }

            if (topRight != null && topRight.GetComponent<PathNode>().badNode)
            {
                topRight = null;
            }

            if (botLeft != null && botLeft.GetComponent<PathNode>().badNode)
            {
                botLeft = null;
            }

            if (botRight != null && botRight.GetComponent<PathNode>().badNode)
            {
                botRight = null;
            }

            int nodeConnection = 0;

            if (top != null)
            {
                ++nodeConnection;
            }

            if (bot != null)
            {
                ++nodeConnection;
            }

            if (left != null)
            {
                ++nodeConnection;
            }

            if (right != null)
            {
                ++nodeConnection;
            }

            if (topLeft != null)
            {
                ++nodeConnection;
            }

            if (topRight != null)
            {
                ++nodeConnection;
            }

            if (botLeft != null)
            {
                ++nodeConnection;
            }

            if (botRight != null)
            {
                ++nodeConnection;
            }

            if (nodeConnection < minConnection)
            {
                badNode = true;
                gM.nodeList.Remove(gameObject);
                gM.badNodeList.Add(gameObject);
                SetColor(Color.red);
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        /*
         * hack method to detect walls
         * set as bad node if wall is detected
         * 
         * can destroy node here as well
         */
        if(collision.gameObject.tag == "Wall")
        {
            if (!collision.isTrigger)
            {
                badNode = true;

                CheckBadNode();
                SetColor(Color.red);

                //destroy node here if bad
            }
        }


        /*
         * hack method to detect refresh objects
         * set node to refresh
         * saves the refresh colider to reference later to check if able to return to normal node
         */
        if(!badNode && collision.gameObject.tag == "Refresh")
        {
            refreshNode = true;

            gM.nodeList.Remove(gameObject);
            gM.refreshNodeList.Add(gameObject);
            CheckBadNode();
            refreshCol = collision;

            SetColor(Color.blue);
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Refresh")
        {
            refreshNode = false;
            refreshCol = null;
            gM.nodeList.Add(gameObject);
            gM.refreshNodeList.Remove(gameObject);

            SetColor(Color.yellow);
        }
    }

    //set color of node function
    public void SetColor(Color color)
    {
        GetComponent<SpriteRenderer>().color = color;
    }

    //functions to store information
    public void SetNodeDist(float nodeD)
    {
        nodeDist = nodeD + 0.01f;
    }

    public void SetMinConnection(int min)
    {
        minConnection = min;
    }

    public void SetGridMaster(GridMaster gridMaster)
    {
        gM = gridMaster;
    }

    /*
     * function to check if refreshcol is still active,
     * if not active add back to main nodelist and remove from refresh nodelist
     */
    public void CheckRefreshCol()
    {
        if(refreshCol != null && !refreshCol.gameObject.activeSelf)
        {
            refreshNode = false;
            refreshCol = null;
            gM.nodeList.Add(gameObject);
            gM.refreshNodeList.Remove(gameObject);

            SetColor(Color.yellow);
        }
    }

    //Pathfinding Functions
    public void ResetPathValue()
    {
        parentNode = null;
        f = 0;
    }

    public void CalculateF(GameObject start, GameObject end)
    {
        float g = Vector2.Distance(transform.position, start.transform.position);
        float h = Mathf.Pow(end.transform.position.x - transform.position.x, 2) + Mathf.Pow(end.transform.position.y - transform.position.y, 2);

        f = g + h;
    }

    public void SetParentNode(GameObject node)
    {
        parentNode = node;
    }
}
