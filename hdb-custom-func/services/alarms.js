const create = (request, config) => {
    const body = request.body;
    const items = body.items;
    return {
        "operation": "upsert",
        "schema": config.alarms.schema,
        "table": config.alarms.table,
        "records": items
    }
}

const get = (hdbCore, body) => {

}

module.exports.create = create
module.exports.get = get
