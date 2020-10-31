using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public static class PathController
{
    private static List<GameObject> openList = new List<GameObject>();
    private static List<GameObject> closedList = new List<GameObject>();

    private static bool searching = false;

    public static List<GameObject> FindPath(GameObject start, GameObject end)
    {

        if(searching)
        {
            return new List<GameObject>();
        }

        searching = true;

        GameObject current = start;
        GameObject previous = start;

        closedList.Add(start);

        List<GameObject> path = new List<GameObject>();

        while (!openList.Contains(end))
        {
           
            GetAvailableNodes(current, start, end);

            if (openList.Count > 0)
            {
                previous = current;
                current = openList[openList.Count-1];
                
                foreach (GameObject n in openList)
                {
                    if (n.GetComponent<PathNode>().f < current.GetComponent<PathNode>().f)
                    {
                        current = n;
                    }
                }
            }

            else
            {
                ResetPathfindingValues();
                Debug.Log("no path");
                return new List<GameObject>();
            }

            //if(current == end)
            //{
            //    ResetPathfindingValues();
            //    break;
            //}

            closedList.Add(previous);
            openList.Remove(previous);
        }

        searching = false; 

        path = FindPathReversed(end);

        ResetPathfindingValues();
        return path;
    }

    private static List<GameObject> FindPathReversed(GameObject end)
    {
        GameObject current = end;

        List<GameObject> path = new List<GameObject>();

        path.Add(current);

        while (current.GetComponent<PathNode>().parentNode != null)
        {
            path.Add(current.GetComponent<PathNode>().parentNode);
            current = current.GetComponent<PathNode>().parentNode;
        }

        path.Reverse();

        

        return path;
    }

    ////function to release nodes from top, bot, left, right to put back into consideration if != previous node
    //private static void ReleasePlusNodes(GameObject current, GameObject previous)
    //{
    //    PathNode currNode = current.GetComponent<PathNode>();

    //    if (currNode.top != previous && closedList.Contains(currNode.top))
    //    {
    //        closedList.Remove(currNode.top);
    //        currNode.top.GetComponent<PathNode>().ResetPathValue();
    //    }

    //    if (currNode.bot != previous && closedList.Contains(currNode.bot))
    //    {
    //        closedList.Remove(currNode.bot);
    //        currNode.top.GetComponent<PathNode>().ResetPathValue();
    //    }

    //    if (currNode.left != previous && closedList.Contains(currNode.left))
    //    {
    //        closedList.Remove(currNode.left);
    //        currNode.top.GetComponent<PathNode>().ResetPathValue();
    //    }

    //    if (currNode.right != previous && closedList.Contains(currNode.right))
    //    {
    //        closedList.Remove(currNode.right);
    //        currNode.top.GetComponent<PathNode>().ResetPathValue();
    //    }

    //}

        //private static void ReleaseCrossNodes(GameObject current, GameObject previous)
        //{
        //    PathNode currNode = current.GetComponent<PathNode>();

        //    if (currNode.top != previous && closedList.Contains(currNode.topRight))
        //    {
        //        closedList.Remove(currNode.topRight);
        //        currNode.top.GetComponent<PathNode>().ResetPathValue();
        //    }

        //    if (currNode.bot != previous && closedList.Contains(currNode.topLeft))
        //    {
        //        closedList.Remove(currNode.topLeft);
        //        currNode.top.GetComponent<PathNode>().ResetPathValue();
        //    }

        //    if (currNode.left != previous && closedList.Contains(currNode.botLeft))
        //    {
        //        closedList.Remove(currNode.botLeft);
        //        currNode.top.GetComponent<PathNode>().ResetPathValue();
        //    }

        //    if (currNode.right != previous && closedList.Contains(currNode.botRight))
        //    {
        //        closedList.Remove(currNode.botRight);
        //        currNode.top.GetComponent<PathNode>().ResetPathValue();
        //    }

        //}

        private static void GetAvailableNodes(GameObject currentNode, GameObject startNode, GameObject endNode)
    {
        PathNode currNode = currentNode.GetComponent<PathNode>();

        //these 4 directions are always added if available
        //must not exist in closedList && openlist

        if (currNode.top != null && !currNode.top.GetComponent<PathNode>().refreshNode && !openList.Contains(currNode.top) && !closedList.Contains(currNode.top))
        {
            currNode.top.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.top.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.top);
        }

        if (currNode.bot != null && !currNode.bot.GetComponent<PathNode>().refreshNode  &&  !openList.Contains(currNode.bot) && !closedList.Contains(currNode.bot))
        {
            currNode.bot.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.bot.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.bot);
        }

        if (currNode.left != null && !currNode.left.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.left) && !closedList.Contains(currNode.left))
        {
            currNode.left.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.left.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.left);
        }

        if (currNode.right != null && !currNode.right.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.right) && !closedList.Contains(currNode.right))
        {
            currNode.right.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.right.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.right);
        }

        //these 4 directions are only added if the adjacent directions are open
        //must not exist in closedList && openlist

        if (currNode.top != null && currNode.right != null && currNode.topRight != null && !currNode.topRight.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.topRight) && !closedList.Contains(currNode.topRight))
        {
            currNode.topRight.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.topRight.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.topRight);
        }

        if (currNode.top != null && currNode.left != null && currNode.topLeft != null && !currNode.topLeft.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.topLeft) && !closedList.Contains(currNode.topLeft))
        {
            currNode.topLeft.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.topLeft.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.topLeft);
        }

        if (currNode.bot != null && currNode.right != null && currNode.botRight != null && !currNode.botRight.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.botRight) && !closedList.Contains(currNode.botRight))
        {
            currNode.botRight.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.botRight.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.botRight);
        }

        if (currNode.bot != null && currNode.left != null && currNode.botLeft != null && !currNode.botLeft.GetComponent<PathNode>().refreshNode  && !openList.Contains(currNode.botLeft) && !closedList.Contains(currNode.botLeft))
        {
            currNode.botLeft.GetComponent<PathNode>().CalculateF(startNode, endNode);
            currNode.botLeft.GetComponent<PathNode>().SetParentNode(currentNode);

            openList.Add(currNode.botLeft);
        }
    }

    

    private static void ResetPathfindingValues()
    {
        foreach(GameObject n in openList)
        {
            n.GetComponent<PathNode>().ResetPathValue();
        }

        foreach (GameObject n in closedList)
        {
            n.GetComponent<PathNode>().ResetPathValue();
        }

        openList.Clear();
        closedList.Clear();
    }
    
}
