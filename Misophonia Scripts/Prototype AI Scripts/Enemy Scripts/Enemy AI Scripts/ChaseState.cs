using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChaseState : BaseBehavior
{
    /* Global Stats */
    public StateController stateCon;
    public EnemySoundController enemySfx;

    public float moveSpeed;
    public float turnSpeed;
    public float distTolerance;
    public float rotSpeed;

    GameObject player;

    GridManager gridManager;

    int dumbCounter;
    const int dumbCheck = 200;
    int stuckCounter;
    const int stuckCheck = 50;

    int nodeNum = 0;

    bool reached;

    List<GameObject> path;
    List<GameObject> prevPath;

    /* Chase Stats */
    bool isInSight;

    /* Charge Stats */
    public GameObject chargeCon;
    
    public float chargeRange;
    public float chargeCD;
    
    bool canCharge;

    /* Throw Stats */
    public GameObject projCon;

    public float throwRange;
    public float throwCD;

    bool canThrow;

    /* Jump Stats */
    public GameObject jumpCon;

    public float jumpRangeMin;
    public float jumpRangeMax;
    public float jumpCD;
    public float minDistFromNode;

    bool canJump;

    /* Attack Stats */
    public float attackRange;
    [HideInInspector] public bool isAttacking;
    
    // Use this for initialization
    void Awake()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        gridManager = GameObject.FindGameObjectWithTag("GridManager").GetComponent<GridManager>() ;

        dumbCounter = 0;
        stuckCounter = 0;
        
        reached = false;
        isInSight = false;

        canCharge = false;
        canThrow = false;
        canJump = false;

        isAttacking = false;

        path = new List<GameObject>();
        prevPath = new List<GameObject>();
    }

    public override void Enter()
    {
        ResetStats();

        StopCoroutine(ChargeTimer());
        StopCoroutine(ThrowTimer());
        StopCoroutine(JumpTimer());

        StartCoroutine(ChargeTimer());
        StartCoroutine(ThrowTimer());
        StartCoroutine(JumpTimer());

        stateCon.CurrState = StateController.State.chase;
    }

    public override void Exit()
    {
        StopCoroutine(ChargeTimer());
        StopCoroutine(ThrowTimer());
        StopCoroutine(JumpTimer());

        canCharge = false;
        canThrow = false;
        canJump = false;
        //stateCon.CurrState = StateController.State.searchEnter;
        stateCon.CurrState = StateController.State.ponderEnter;
    }

    public override void StateLoop()
    {
        StuckCheck();

        if (isAttacking)
        {


        }

        else if (projCon.activeSelf == true)
        {

        }

        

        else if (jumpCon.activeSelf == true)
        {

        }

        else if (chargeCon.activeSelf == true)
        {

        }

        else if (isInSight) 
        {
            Vector3 target = player.transform.position - transform.position;
            Vector2 currPos = transform.position;
            float distA = Vector2.Distance(currPos, player.transform.position);

            if (canCharge && distA <= chargeRange)
            {
                var newDir = Quaternion.LookRotation(target, Vector3.forward);
                newDir.x = 0;
                newDir.y = 0;
                transform.rotation = newDir;

                chargeCon.SetActive(true);
                canCharge = false;
                
                StartCoroutine(ChargeTimer());
                return;
            }

            else if (canThrow && distA >= throwRange)
            {
                var newDir = Quaternion.LookRotation(target, Vector3.forward);
                newDir.x = 0;
                newDir.y = 0;
                transform.rotation = newDir;

                projCon.SetActive(true);
                canThrow = false;

                StartCoroutine(ThrowTimer());
                return;
            }

            else
            {
                var newDir = Quaternion.LookRotation(target, Vector3.forward);
                newDir.x = 0;
                newDir.y = 0;
                transform.rotation = Quaternion.Slerp(transform.rotation, newDir, Time.deltaTime * rotSpeed);

                transform.position = Vector2.MoveTowards(transform.position, player.transform.position, moveSpeed * Time.deltaTime);
                ++dumbCounter;

                enemySfx.PlayChase();
            }

            if (distA <= attackRange && stateCon.CurrState == StateController.State.chase && !isAttacking && chargeCon.activeSelf != true && projCon.activeSelf != true && jumpCon.activeSelf != true)
            {       
                player.GetComponent<Struggle>().BeginStruggle();
                isAttacking = true;
                stateCon.CurrState = StateController.State.wait;
                return;
            }
        }


        else
        {
            

            Vector3 target = player.transform.position - transform.position;
            Vector2 selfPos = transform.position;
            float distZ = Vector2.Distance(selfPos, player.transform.position);

            GameObject nearestNode = gridManager.GetClosestNode(player.transform.position);

            float playerDistFromNode = Vector2.Distance(player.transform.position, nearestNode.transform.position);

            if (playerDistFromNode < minDistFromNode && canJump && distZ >= jumpRangeMin && distZ <= jumpRangeMax)
            {
                Debug.Log("jup");

                var newDir = Quaternion.LookRotation(target, Vector3.forward);
                newDir.x = 0;
                newDir.y = 0;
                transform.rotation = newDir;

                jumpCon.SetActive(true);
                canJump = false;

                StartCoroutine(JumpTimer());
                return;
            }

            if ((path.Count == 0 || dumbCounter >= dumbCheck) && path != prevPath)
            {
                ChasePath();
            }   

            if (path.Count > 0 && !reached)
            {
                {
                    //Vector3 target = new Vector3(gridManager.GridToWorld(path[nodeNum]).x, gridManager.GridToWorld(path[nodeNum]).y, 0) - transform.position;
                    Vector3 targetPos = path[nodeNum].transform.position - transform.position;
                    var newDir = Quaternion.LookRotation(targetPos, Vector3.forward);
                    newDir.x = 0;
                    newDir.y = 0;
                    transform.rotation = Quaternion.Slerp(transform.rotation, newDir, Time.deltaTime * rotSpeed);
                    
                    //transform.position = Vector2.MoveTowards(transform.position, gridManager.GridToWorld(path[nodeNum]), moveSpeed * Time.deltaTime);
                    transform.position = Vector2.MoveTowards(transform.position, path[nodeNum].transform.position, moveSpeed * Time.deltaTime);
                    ++dumbCounter;

                    enemySfx.PlayChase();

                    Vector3 currPos = transform.position;

                    //float distA = Vector2.Distance(currPos, gridManager.GridToWorld(path[path.Count - 1]));
                    float distA = Vector2.Distance(currPos, path[path.Count - 1].transform.position);

                    if (currPos == path[path.Count - 1].transform.position || distA <= distTolerance)
                    {
                        stateCon.CurrState = StateController.State.chaseExit;
                        return;
                    }

                    else if (path.Count > 0)
                    {
                        float distB = Vector2.Distance(currPos, path[nodeNum].transform.position);

                        if (distB <= distTolerance && !reached && nodeNum < path.Count - 1)
                        {
                            ++nodeNum;
                            dumbCounter = 0;
                        }
                    }
                }
            }
        }
        
    }

    public void SetIsInSight(bool inSight)
    {
        isInSight = inSight;
    }

    public bool GetIsInSight()
    {
        return isInSight;
    }

    IEnumerator ChargeTimer()
    {
        yield return new WaitForSecondsRealtime(chargeCD);
        canCharge = true;
    }

    IEnumerator ThrowTimer()
    {
        yield return new WaitForSecondsRealtime(throwCD);
        canCharge = true;
    }

    IEnumerator JumpTimer()
    {
        yield return new WaitForSecondsRealtime(jumpCD);
        canJump = true;
    }

    public void ChaseInterrupt()
    {
        stateCon.nextState = StateController.State.chaseEnter;

        if (stateCon.nextState != stateCon.GetCurrEnterState())
        {
            stateCon.interrupt = true;
            return;
        }
    }

    public override void ResetStats()
    {
        reached = false;

        if (path != null)
        {
            path.Clear();
        }
      
        if (prevPath != null)
        {
            prevPath.Clear();
        }
        nodeNum = 0;
        dumbCounter = 0;
        stuckCounter = 0;

        reached = false;
        isAttacking = false;
    }

    bool ChasePath()
    {
        prevPath = path;
        path = PathController.FindPath(gridManager.GetClosestNode(gameObject.transform.position), gridManager.GetClosestNode(player.transform.position));
        nodeNum = 0;
        reached = false;
        dumbCounter = 0;

        ++stuckCounter;

        if (path.Count <= 0 || path == null)
        {
            return false;
        }

        return true;
    }

    void StuckCheck()
    {
        if (stuckCounter >= stuckCheck)
        {

            Vector3 stuckPos = transform.position;

            //Point p = gridManager.WorldToGrid(transform.position);
            Vector3 unstuckPos = transform.position + new Vector3(0.1f, 0.1f, 0);

            //transform.position = Vector3.MoveTowards(transform.position, gridManager.GridToWorld(p), Time.deltaTime);
            transform.position = Vector3.MoveTowards(transform.position, unstuckPos, Time.deltaTime);

            if (transform.position != stuckPos)
            {
                stuckCounter = 0;
            }

        }
    }

    // Update is called once per frame
    void Update ()
    {
		
        if(Input.GetKeyDown(KeyCode.J))
        {
            canCharge = true;
        }

        if (Input.GetKeyDown(KeyCode.K))
        {
            canThrow = true;
        }

        if (Input.GetKeyDown(KeyCode.L))
        {
            canJump = true;
        }

    }
}
